install.packages('reticulate')
install.packages('rgee')

remotes::install_github("r-spatial/rgee")

library(rgee)
library(reticulate)

ee_install(py_env = "insert_python_env_path") 
# mine "C:\\Users\\hp\\miniconda3\\envs\\rgee_py\\python.exe"

# comtrollare il path di python. deve essere quello del virtual env dedicato a rgee

ee_Inizialize()

#restart

py_check()

# provare a replicare su un altro pc per convalidare il metodo di installazione
# pagari sul pc di simone
