#!/bin/bash

#### ABOUT: 	VCS application that allows for multiple users to work on a project
#### NAME:	Daniel J McGuinness
#### DATE:	15/10/16

while [ "$choice" != 0 ]
do
	clear
	cat << MENU
-------------------------------------
Main Menu
-------------------------------------
1. Start New Project
2. Select Project
0. Quit
-------------------------------------
MENU
	read choice
	case "$choice" in 
		1) 	
			#prompt user to choose name for folder
			echo -n "Choose a name for your new project: "
			read projectname
			echo "$STR"

			#test to see if directory already exists
			if [ ! -d projects/"$projectname" ];
			then
				
				#create group for project
				sudo groupadd "$projectname"

				#assign current user to group 
				sudo usermod -a -G "$projectname" $USER

				#create project directory + subdirectories
				mkdir -p projects/"$projectname"/archive
				mkdir projects/"$projectname"/log
				touch ./projects/"$projectname"/log/log

				#assign to group 
				sudo chown -R $USER:$projectname projects/"$projectname"

				#change access permissions to user only 
				chmod 770 projects/"$projectname"

				#inform user that project has been created
				echo "project successfully created"
	
			else
				#inform user that project already exists
				echo "project could not be created: project with this name already exists"
			fi

			echo "press any key to continue"
			read



		;;
		2) 	
			clear
				echo "avaliable projects: "
				echo "$STR"
				ls --format=single-column ./projects
				echo "$STR"
				echo -n "enter the project you would like to view: "
				read projectname
				echo "$STR"

				#test to see if project exists
				if [ -d ./projects/"$projectname" ] && [ ! "$projectname" == "" ];
				then
					#display project menu
					projectchoice=1
					while [ "$projectchoice" != 0 ]
						do
							clear
							echo "-------------------------------------"
							echo "$projectname Menu"
							echo "-------------------------------------"
							echo "1. Create File"
							echo "2. Remove File"
							echo "3. Edit File"
							echo "4. View Change Log"
							echo "5. Finish & Zip Project"
							echo "6. Change Access Permissions"
							echo "7. Delete Project"
							echo "8. Archive Project"
							echo "9. Restore from Archive"
							echo "0. Return to Main Menu"
							echo "-------------------------------------"
							echo "file list: "
							echo "-------------------------------------"
							ls --format=single-column ./projects/$projectname
							echo "-------------------------------------"

							read projectchoice
							case "$projectchoice" in 
								1)	#ADD FILE

									echo "Enter the name of the new file: "
									read filename

									if [ ! -f ./projects/"$projectname"/"$filename" ];
									then
										#create file in given project
										touch ./projects/"$projectname"/"$filename"

										#set permission to current user only
										chmod 700 ./projects/"$projectname"/"$filename"

										#ask users for input
										echo "enter text for $filename: (Ctrl + D to end input)"
										cat > ./projects/"$projectname"/"$filename"

										#allow group users to access file
										chmod 770 ./projects/"$projectname"/"$filename" 

										#add creation info to log
										d=$(date -u)
										echo "File Created: $filename - Date: $d - User: $USER" >> ./projects/"$projectname"/log/log 

										#ask users to enter a comment for the log
										echo "do you wish to add a comment to the log?(y/n)"
										read userchoice

										#loop until user gives valid response
										while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
										do
											echo "do you wish to add a comment to the log?(y/n)"
											read userchoice
											echo "$userchoice"
										done

										if [ "$userchoice" == "y" ];
										then
											clear
											echo "Enter commment below:(Ctrl + D to end input)"
											echo "$USER comment:">> ./projects/"$projectname"/log/log 
											cat >> ./projects/"$projectname"/log/log 
										fi

										echo "" >> ./projects/"$projectname"/log/log 
									else
										echo "the file $filename already exists"
									fi
									#ensure text can be read by user
									echo "press any key to continue"
									read
								;;
								2)	#DELETE FILE

									echo "Avaliable files:"
									ls --format=single-column ./projects/"$projectname"
									echo "Which file would you like to delete: "
									read filename

									#confirm user wishes to delete file
									if [ -f ./projects/"$projectname"/"$filename" ];
									then
										echo "Are you sure you wish to delete $filename ?(y/n)"
										read userchoice

										#loop until user gives valid response
										while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
										do
											echo "Are you sure you wish to delete $filename ?(y/n)"
											read userchoice
										done
										
										#process user's choice
										if [ "$userchoice" == "y" ];
										then
											rm -f ./projects/"$projectname"/"$filename"
											d=$(date -u)
											echo "File Deleted: $filename - Date: $d - User: $USER" >> ./projects/"$projectname"/log/log 
												
											echo "$STR"
											echo "do you wish to add a comment?(y/n)"
											read userchoice

											#loop until user gives valid response
											while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
											do
												echo "do you wish to add a comment?(y/n)"
												read userchoice
												echo "$userchoice"
											done

											if [ "$userchoice" == "y" ];
											then
												clear
												echo "Enter commment below:(Ctrl + D to end input)"
												echo "$USER comment:">> ./projects/"$projectname"/log/log 
												cat >> ./projects/"$projectname"/log/log 
											fi

											echo "" >> ./projects/"$projectname"/log/log 
										else
											echo "file was not deleted"
										fi
										
									else
										echo "This file doesn't exist"
									fi

									#ensure text can be read by user
									echo "press any key to continue"
									read
										
								;;
								3)	#EDIT FILE

									echo "Avaliable files:"
									ls --format=single-column ./projects/"$projectname"
									echo "Which file would you like to edit: "
									read filename

									if [ -f ./projects/"$projectname"/"$filename" ];
									then
										clear
										echo "Current contents of $filename"
										echo "$STR"
										cat ./projects/"$projectname"/"$filename" 
										echo "$STR"

										echo "Are you sure you wish to edit $filename ?(y/n)"
										read userchoice

										#loop until user gives valid response
										while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
										do
											echo "Are you sure you wish to edit $filename ?(y/n)"
											read userchoice
										done
										
										#process user's choice
										if [ "$userchoice" == "y" ];
										then
											#set access to only current user while editing
											chmod 700 ./projects/"$projectname"/"$filename" 

											echo "Editing: (Ctrl + D to end input)"

											#start edit
											cat > ./projects/"$projectname"/"$filename" 

											#return access to group
											chmod 770 ./projects/"$projectname"/"$filename"

											#add edit info to log
											d=$(date -u)
											echo "File Edited: $filename - Date: $d - User: $USER" >> ./projects/"$projectname"/log/log 

											#ask users to enter a comment for the log
											echo "do you wish to add a comment to the log?(y/n)"
											read userchoice

											#loop until user gives valid response
											while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
											do
												echo "do you wish to add a comment to the log?(y/n)"
												read userchoice
												echo "$userchoice"
											done

											if [ "$userchoice" == "y" ];
											then
												clear
												echo "Enter commment below:(Ctrl + D to end input)"
												echo "$USER comment:">> ./projects/"$projectname"/log/log 
												cat >> ./projects/"$projectname"/log/log 
											fi

											echo "" >> ./projects/"$projectname"/log/log 
										else
											echo "file was not changed"
										fi

									else
										echo "This file doesn't exist"
									fi

									echo "$STR"
									echo "press any key to continue"
									read
																	
								;;
								4)	#VIEW CHANGE LOG

									clear
									cat ./projects/"$projectname"/log/log 
									echo "$STR"
									echo "press any key to continue"
									read
								;;
								5)	#FINISH & ZIP PROJECT
									
									#assign output temp name
									cp -r ./projects/"$projectname" ./temp
									
									#reduce file size to essentials
									rm -rf ./temp/archive
									rm -rf ./temp/log
									
									#zip project
									tar cvzf "$projectname"Final.tar.gz temp

									#remove copy of project
									rm -rf ./temp
									
									#move final project to 'finished' folder
									mkdir ./finished
									mv ./"$projectname"Final.tar.gz ./finished/"$projectname"Final.tar.gz
											
									echo "archive successful"
									echo "press any key to continue"
									read
								;;
								6)	#CHANGE ACCESS PERMISSIONS

									while [ "$accesschoice" != 0 ]
									do
										clear
										echo "-------------------------------------"
										echo "$projectname Access Permissions"
										echo "-------------------------------------"
										echo "1. Add User to Group"
										echo "2. Remove User from Group"
										echo "0. Return to project overview"
										echo "-------------------------------------"

										read accesschoice
										case "$accesschoice" in 
											1) #ADD USER TO GROUP

												clear
												echo "All Local System Users:"
												ls --format=single-column /home
												echo "$STR"
												echo "Which user would you like to add?"
												read adduser

												echo "$STR"
												echo "Are you sure you wish to add this user?(y/n)"
												read userchoice

												#loop until user gives valid response
												while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
												do
													echo "Are you sure you wish to add $adduser ?(y/n)"
													read userchoice
													echo "$userchoice"
												done
												if [ "$userchoice" == "y" ];
												then
													#add user to group
													sudo usermod -a -G "$projectname" $adduser

													#inform that user has been added to project
													echo "$adduser added to $projectname"
												else
													echo "user not added"
												fi
												
												echo "press any key to continue"
												read
											;;
											2) #REMOVE USER FROM GROUP

												clear
												echo "All Local System Users:"
												ls --format=single-column /home
												echo "$STR"
												echo "Which user would you like to delete?"
												read removeuser

												if [ $removeuser != $USER ];
												then

													echo "$STR"
													echo "Are you sure you wish to add this user?(y/n)"
													read userchoice

													#loop until user gives valid response
													while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
													do
														echo "Are you sure you wish to add $adduser ?(y/n)"
														read userchoice
														echo "$userchoice"
													done
													if [ "$userchoice" == "y" ];
													then

														#inform that user has been removed
														echo "$removeuser added to $projectname"
														
														#remove user
														gpasswd -d "$removeuser" "$projectname"
													else
														echo "user not be removed"
													fi
												else
													echo "Cannot remove yourself from group"
												fi
												echo "$STR"
												echo "press any key to continue"
												read
											;;
										esac
									done
								;;
								7)	#DELETE PROJECT	
								
									
									echo "Are you sure you wish to delete this project?(y/n)"
									read userchoice

									#loop until user gives valid response
									while [ "$userchoice" != "y" ] && [ "$userchoice" != "n" ]
									do
										echo "Are you sure you wish to delete $filename ?(y/n)"
										read userchoice
										echo "$userchoice"
									done
									if [ "$userchoice" == "y" ];
									then
										#delete the project directory along with all
										#the files and sub directories held within it.
										rm -rf ./projects/"$projectname"

										#delete group associated with project
										sudo groupdel "$projectname"
										
										#ensure user is returned to main menu
										projectchoice=0

										#inform user that project has been deleted
										echo "project deleted"
									else
										echo "project not deleted"
									fi
									echo "$STR"
									echo "press any key to continue"
									read						
								;;
								8)	#ARCHIVE PROJECT
						
									#assign output temp name
									cp -r ./projects/"$projectname" ./"$projectname"
									
									#remove archive to prevent too many folders
									rm -rf ./"$projectname"/archive
									
									#zip project
									tar cvzf "$projectname".tar.gz "$projectname"
									d=$(date +%Y%m%d%H%M)
									mv ./"$projectname".tar.gz ./projects/"$projectname"/archive/"$d".tar.gz

									#remove temp
									rm -rf ./"$projectname"

									#inform user
									echo "project archived!"
									echo "$STR"
									echo "press any key to continue"
									read

								;;
								9)	#RESTORE FROM ARCHIVE
							
									echo "Avaliable back-ups"
									ls --format=single-column ./projects/"$projectname"/archive
									echo "$STR"
									echo "Enter which backup you would like to restore: "
									read restorename		

									if [ -f ./projects/"$projectname"/archive/"$restorename" ] && [ ! "$restorename" == "" ];
									then
										#copy files to be moved to restore
										cp ./projects/"$projectname"/archive/"$restorename" ./"$restorename"
										cp -rf ./projects/"$projectname"/archive ./archivetemp

										#extract file
										tar -xvzf "$restorename"

										#tidy up main folder
										mv ./archivetemp ./"$projectname"/archive
										rm -rf ./"$restorename"

										#replace project
										rm -rf ./projects/"$projectname"
										mv ./"$projectname" ./projects/$projectname

									else
										echo "input is invalid"
									fi
									
									echo "press any key to continue"
									read	
								;;
							esac
						done
				else
					echo "project not found, returning to main menu"
					echo "$STR"
					echo "press any key to continue"
					read
				fi	
		;;
	esac
done


