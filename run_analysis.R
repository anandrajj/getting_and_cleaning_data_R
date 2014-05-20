get_descriptive_act_name <- function(lablefile="activity_labels.txt",activityfile="y_test.txt"){
    var <- c(NA,NA)
    
    #Read activity_lables.txt to load the descriptive name into a Data Frame.
    
    if (file.exists(lablefile)) {
        var <- read.table(lablefile,stringsAsFactors = FALSE)
    } else {
        print("Invalid Activity lables file")
        return(var)
    }
    colnames(var)[1] <- "ACTIVITY INDEX"
    colnames(var)[2] <- "ACTIVITY NAME"
    
    if (file.exists(activityfile)) {
        index <- read.table(activityfile,stringsAsFactors = FALSE)
    } else {
        print("Error reading Activity file")
        return(index)
    }
    
    k = 0
    for(i in index) {
        if(k == 0) {
            dfa <- data.frame(Activity=var[i,2])
            k = 1
        } else{
            dl2 <- data.frame(Activity=var[i,2])
            dfa <- rbind(dfa,dl2)        
        }
        
    }
    return(dfa)
}

assign_col_names <- function(valuesfile="X_test.txt",featuresfile="features.txt") {
    
    if(file.exists(valuesfile) && file.exists(featuresfile)) {
        dfv   <- read.table(valuesfile,stringsAsFactors=FALSE)
        names <- read.table(featuresfile,stringsAsFactors=FALSE)
        for(i in 1:nrow(names)){
            colnames(dfv)[i] <- names[i,2]
        }
    } else {
        print("Pass valid filenames")
        return("Error")
    }  
    return(dfv)
}

read_subject <- function(subjectfile="y_test.txt") {
    
    if(file.exists(subjectfile)) {
        sub <- read.table(subjectfile)
        colnames(sub)[1] <- "Sub"
        
    } else {
        
        Print("Supply valid file name")
        return("error")
    }
    
    return(sub)
    
}

run_analysis <- function(){
    
    #format Train data set
    dfs_train <- read_subject("train/subject_train.txt")
    dfv_train <- assign_col_names("train/X_train.txt","features.txt")
    dfa_train <- get_descriptive_act_name("activity_labels.txt","train/y_train.txt")
    train <- cbind(dfs_train,dfa_train,dfv_train)
    
    #format Test data set
    dfs_test <- read_subject("test/subject_test.txt")
    dfv_test <- assign_col_names("test/X_test.txt","features.txt") 
    dfa_test <- get_descriptive_act_name("activity_labels.txt","test/y_test.txt")
    test <- cbind(dfs_test,dfa_test,dfv_test)
    
    #merge test & train data sets
    total <- rbind(train,test)
    
    #extract only mean & standard devation columns
    mean_col_subset <- total[,grep("mean()",names(total),fixed=TRUE)]
    stdd_col_subset <- total[,grep("std()",names(total),fixed=TRUE)]
    
    #create a dataframe with only Subject & Activity
    std_mean_subset <- total[,c(1,2)]
    meancolname <- names(mean_col_subset)
    stdcolname <- names(stdd_col_subset)
    col_count <- ncol(mean_col_subset)
    
    #merge mean & standard deviation in the same order as original dataset
    for(i in 1:col_count){
        std_mean_subset <- cbind(std_mean_subset,mean_col_subset[meancolname[i]],stdd_col_subset[stdcolname[i]])
    }
    #convert to data table to caclulate mean by subject and activity.
    library("data.table")
    dt <- as.data.table(std_mean_subset)
    dt_mean <- dt[,lapply(.SD,mean), by = list(Sub,Activity)]
    srt_dt_mean <- dt_mean[order(Sub,Activity)]
    write.table(srt_dt_mean, file="tidy_file.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
}
