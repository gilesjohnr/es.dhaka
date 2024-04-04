# Make metadata keys
key_target_names <- as.data.frame(readxl::read_xlsx(file.path(getwd(), "data-raw/key_target_names.xlsx")))

for (i in 1:nrow(key_target_names)) {

     if (key_target_names$target_name_concise[i] == "NA") {

          key_target_names$target_name_concise[i] <- key_target_names$target_name_unique[i]

     }
}

key_target_names <- key_target_names[order(key_target_names$target_name_concise),]
key_target_names$include[is.na(key_target_names$include)] <- 1
key_target_names <- key_target_names[,colnames(key_target_names) != 'description']

write.csv(key_target_names, file.path(getwd(), "data-raw/key_target_names.csv"), row.names=FALSE)
usethis::use_data(key_target_names, overwrite=TRUE)
