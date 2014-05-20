## Getting & Cleaning Data - Project


This document helps to understand the R script run_analysis.R developed for the course project. Aim of the project is to merege test & training dataset,assign descriptive activity names, extract only meand & standard deveation columns and create a tidy file mean of extracted columns grouped by Subject & Activity.

### How to execute the code?

In order to the script, copy all the input files & run_analysis.R to working directory of R. Source the script and enter function *run_analysis()* in the console. Once the execution completes tidy_file.txt will be created in the working directory.

*Note:Before reexecution delete or move tidy_file.txt from working direcotry*

### Functions

The script includes three functions to perform same operation on both test and train datasets.

* get_descriptive_act_name() - Uses activity lable file(*activity_lables.txt*) and acivity code file (*y_test.txt or y_train.txt*) to assign descriptive activity names to the activity. Loads the read data into a dataframe and names the column as *Activity*.

* assign_col_names() - Reads the main data file(*X_test.txt or X_train.txt*) into dataframe and assigns the meaning ful column name using the features file(*features.txt*). Columns are given meaningful names to extract only mean and standard deviation columns for the final processing.

* read_subject() - Reads the (*subject_test.txt or subject_train.txt*) and loads the data into a single column dataframe with name *Sub*.


### Main Processing

**Step 1**

Main processing the script executes the above functions to get 3 dataframes (subject,values and activity) & merges them column wise to get a signle data frame. This processing is done for both test & training datasets to get dataframes *test and train*. This complets the task of assining descriptive activity lables to the dataset.

**Step 2**
*test & train* dataframes are merged using rbind(row level) to form single dataframe *total*. This complets the task of merging test and training data.

**Step 3**
From the *total* dataframe, two new dataframes one with mean and another with standard deviations are extracted. Then using a for loop, these two dataframes are merged column by column to get signle dataframe of mean and standard deviations with related values adjecent to each other. With this only mean and standard deviations are extracted to seperate dataframe.

**Step 4**
In this step, dataframe is converted to a datatable. Then *lapply* is used apply mean function on all columns of datatable grouped by *Subject* and *Activity* . On completion, the output is sorted using *Subject and Activity* the written to output file *tidy_file.txt*. With this all steps of the project is completed.


***Written by Anandraj Jagadeesan***

