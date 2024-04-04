# Make full list of all experiment names and cross reference to the correct standard curve data source

path_in <- c(
     "/Users/johngiles/Library/CloudStorage/Dropbox/Projects/IDM/ES_multipathogen/ES TAC/BEED TAC/EXCEL",
     "/Users/johngiles/Library/CloudStorage/Dropbox/Projects/IDM/ES_multipathogen/ES TAC/ES080217432 - ES090317455 TAC Cards/Excel",
     "/Users/johngiles/Library/CloudStorage/Dropbox/Projects/IDM/ES_multipathogen/ES TAC/G- TAC Cards for Polio ES/Excel",
     "/Users/johngiles/Library/CloudStorage/Dropbox/Projects/IDM/ES_multipathogen/ES TAC/Qadri Enteric TAC/EXCEL",
     "/Users/johngiles/Library/CloudStorage/Dropbox/Projects/IDM/ES_multipathogen/ES TAC/KEPS TAC/EXCEL"
)

# Set file paths
xls_file_paths <- unlist(sapply(path_in, function(x) list.files(x, pattern='.xls', full.names=TRUE)))

# Get full list of experiment names

experiment_names <- vector()
experiment_dates <- vector()

for (i in seq_along(xls_file_paths)) {

     tmp <- xlsx::read.xlsx2(xls_file_paths[i], sheetIndex=1, header=FALSE, colIndex = 1:10)
     exp_name <- tmp[which(tmp[,1] == 'Experiment Name'), 2]

     experiment_names <- c(experiment_names, stringr::str_sub(exp_name, start=12))
     experiment_dates <- c(experiment_dates, stringr::str_sub(exp_name, end=10))

}

out <- data.frame(
     experiment_date = as.Date(experiment_dates),
     experiment_name = experiment_names,
     standard_curve_file_name = NA
)

# Fix conspicuous typos

#out$experiment_name[out$experiment_name == 'ES TAC CARD-04'] <- 'G- ES TAC CARD 04'
#out$experiment_name[out$experiment_name == 'ES TAC G- CARD 29'] <- 'G- ES TAC CARD 29'
#out$experiment_name[out$experiment_name == ' G- ES TAC CARD 31'] <- 'G- ES TAC CARD 31'
#out$experiment_name[out$experiment_name == 'G- ES TAC  CARD 32'] <- 'G- ES TAC CARD 32'
#out$experiment_name[out$experiment_name == 'ES BEES TAC CARD 46'] <- 'ES BEED TAC CARD 46'
#out$experiment_name[out$experiment_name == 'ES BEED CARD 004'] <- 'ES BEED TAC CARD 004'
#out$experiment_name[out$experiment_name == 'ES BEED CARD 20'] <- 'ES BEED TAC CARD 20'
#out$experiment_name[out$experiment_name == '22 ES QADRI ENTERIC CARD 05'] <- 'ES QADRI ENTERIC CARD 05'
#out$experiment_name[out$experiment_name == 'QADRI ENREIC CARD 51'] <- 'QADRI ENTERIC CARD 51'
#out$experiment_name[out$experiment_name == 'ES KEPS CARD 22'] <- 'ES KEPS TAC CARD 22'

out <- out[order(out$experiment_name),]


# Maled 2, G, and Beed used "3 std card bg" standard curve
sel <- grep('MALED', out$experiment_name, value=FALSE, ignore.case=TRUE)
out[sel, 'standard_curve_file_name'] <- '3 std card BG-SP_08-01-23'

sel <- grep('G-', out$experiment_name, value=FALSE, ignore.case=FALSE)
out[sel, 'standard_curve_file_name'] <- '3 std card BG-SP_08-01-23'

sel <- grep('BEED', out$experiment_name, value=FALSE, ignore.case=TRUE)
out[sel, 'standard_curve_file_name'] <- '3 std card BG-SP_08-01-23'

# Qadri card design
sel <- grep('QADRI', out$experiment_name, value=FALSE, ignore.case=TRUE)
out[sel, 'standard_curve_file_name'] <- 'Qadri-TAC_Std_corrected_08-01-23'

# KEPS card design
sel <- grep('KEPS', out$experiment_name, value=FALSE, ignore.case=TRUE)
out[sel, 'standard_curve_file_name'] <- 'KEPS_Std_corrected_08-01-23'

sel <- which(out$experiment_name %in% c('KEPS_Std1', 'KEPS_Std2', 'KEPS_Std3'))
out[sel, 'standard_curve_file_name'] <- NA


write.csv(out, file.path(getwd(), 'data-raw/key_standard_curves.csv'), row.names = FALSE)

key_standard_curves <- out
usethis::use_data(key_standard_curves, overwrite=TRUE)
