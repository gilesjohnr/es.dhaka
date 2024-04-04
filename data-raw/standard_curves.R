library(readxl)
library(glue)

key <- read.csv(file.path(getwd(), "data-raw/key_target_names.csv"))

logmean <- function(x) {

     x <- as.numeric(x)
     x[x <= 0] <- NA
     m <- exp(mean(log(x), na.rm=TRUE))
     if (is.nan(m)) m <- NA
     return(m)

}

get_target_name_concise <- function(df, key) {

     # Get concise names for all exact matches

     for (i in 1:nrow(df)) {

          sel <- which(key$target_name_unique == df$target_name_unique[i])

          if (length(sel) > 0) {

               df$target_name_concise[i] <- key$target_name_concise[sel]

          } else {

               sel <- which(key$target_name_concise == df$target_name_unique[i])
               if (length(sel) > 0) df$target_name_concise[i] <- key$target_name_concise[sel]

          }

     }


     # Get concise names for remaining targets using fuzzy matching

     for (i in 1:nrow(df)) {

          if (is.na(df$target_name_concise[i])) {

               sel <- agrep(df$target_name_unique[i], key$target_name_unique, value=FALSE, ignore.case=TRUE, max=list(all=0.1))

               if (length(sel) > 0) {

                    df$target_name_concise[i] <- key$target_name_concise[sel]

               } else {

                    sel <- agrep(df$target_name_unique[i], key$target_name_concise, value=FALSE, ignore.case=TRUE, max=list(all=0.1))
                    if (length(sel) > 0) df$target_name_concise[i] <- key$target_name_concise[sel]

               }

          }

     }

     return(df$target_name_concise)

}

#-------------------------------------------------------------------------------

file_name <- '3 std card BG-SP_08-01-23'

df <- as.data.frame(readxl::read_xls(file.path(getwd(), glue("data-raw/standard_curves/raw/{file_name}.xls"))))

df$ct_value <- apply(df[,colnames(df) %in% c('CT1', 'CT2')], 1, FUN = logmean)

df <- data.frame(
     file_name = file_name,
     target_name_unique = df$`Target Name`,
     target_name_concise = NA,
     n_copies = df$`copy/rxn`,
     ct_value = df$ct_value
)

df$target_name_concise <- get_target_name_concise(df, key)
df <- df[order(df$target_name_concise, df$n_copies),]

write.csv(df, file=file.path(getwd(), glue("data-raw/standard_curves/processed/{file_name}.csv")), row.names=FALSE)


#-------------------------------------------------------------------------------

file_name <- 'KEPS_Std_corrected_08-01-23'

df <- as.data.frame(xlsx::read.xlsx(file.path(getwd(), glue("data-raw/standard_curves/raw/{file_name}.xlsx")), sheetIndex=2))

# Remove empye cells
sel <- apply(df, 1, function(x) ifelse(all(is.na(x)), F, T))
df <- df[sel,]

# Fix empty target names
df <- df %>% fill(Targets, .direction='down')

# Remove NFW observations
sel <- df$Copy.per.ul == 'NFW'
df <- df[!sel,]

# Undefined to NA
df[df == 'Und'] <- NA


df$ct_value <- apply(df[,colnames(df) %in% c('Ct1', 'Ct2', 'Ct3')], 1, FUN = logmean)


df <- data.frame(
     file_name = file_name,
     target_name_unique = df$`Targets`,
     target_name_concise = NA,
     n_copies = df$Copy.per.rxn..0.2.ul.template.,
     ct_value = df$ct_value
)

df$target_name_concise <- get_target_name_concise(df, key)
df <- df[order(df$target_name_concise, df$n_copies),]

write.csv(df, file=file.path(getwd(), glue("data-raw/standard_curves/processed/{file_name}.csv")), row.names=FALSE)


#-------------------------------------------------------------------------------

file_name <- 'Qadri-TAC_Std_corrected_08-01-23'

df <- as.data.frame(xlsx::read.xlsx(file.path(getwd(), glue("data-raw/standard_curves/raw/{file_name}.xlsx")), sheetIndex=2))

# Remove empty cells
sel <- apply(df, 1, function(x) ifelse(all(is.na(x)), F, T))
df <- df[sel,]

# Fix empty target names
df <- df %>% fill(Target.Name, .direction='down')

# Remove NFW observations
sel <- df$Sample.Name == 'NFW'
df <- df[!sel,]

# Undefined to NA
df[df == 'Und'] <- NA

df <- data.frame(
     file_name = file_name,
     target_name_unique = df$`Target.Name`,
     target_name_concise = NA,
     n_copies = df$Copy.rxn..0.2.ul.,
     ct_value = df$CT
)

df$target_name_concise <- get_target_name_concise(df, key)
df <- df[order(df$target_name_concise, df$n_copies),]

write.csv(df, file=file.path(getwd(), glue("data-raw/standard_curves/processed/{file_name}.csv")), row.names=FALSE)


#-------------------------------------------------------------------------------

# Combine
tmp <- list.files(file.path(getwd(), "data-raw/standard_curves/processed/"), full.names = TRUE)
standard_curves <- do.call(rbind, lapply(tmp, read.csv))

write.csv(standard_curves, file=file.path(getwd(), glue("data-raw/standard_curves.csv")), row.names=FALSE)
usethis::use_data(standard_curves, overwrite=TRUE)
