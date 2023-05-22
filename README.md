# Plant-Image-Analysis

IMAGE ANALYSIS STEPS 
1) Download the images to your machine. 

2) Rename the images such that they are in this format: 
“CTL_Nd_before_678910”
-	CTL being the control group, FRZ being freeze group
-	Nd is the genotype
-	Before is the day information. For example, before in this experiment means 2 days before the freeze stress.
-	678910 are the replicates in that image.

3) I usually make a separate folder for Arabidopsis and Brassica and have 3 folders named “done”, “R_results” and “results” inside the initial folder. After running each image through plantCV put the images you have processed inside the “done” folder.

4) Run the PlantCV script named “plantcv_Area.ipynb” using either Google Colab or Jupyter Notebook. If you’re using Google Colab, you need to upload the images to your workspace. You’ll also need to change the path given inside PlantCV to match the path of your worksape inside your laptop. Run the script for each image. (To be able to run PlantCV you need to first install a few libraries, PlantCV, Jupyter Notebook and Anaconda. You can do this by following the instructions that are in another folder in the drive.)

6) After you have all of your area analysis results in one folder “results”, run the R script named “plant_area_2023”. Do not forget to change the path just like before. This will create a CSV containing all replicates, genotypes, treatment, day and area pixel information. And it’ll make several different plots. It’ll also put all of these inside “R_results” folder that you’ve created before.

Important note:
-	If you have more than 10 replicates you will need to change the R script so that it can parse the replicate string correctly.

CRON JOBS

1)	Follow the instructions in this document to get started with the Raspberry Pi: raspberryPiNotes - Google Docs. Follow the instructions until the Cron Job step.
2)	Run this command to edit the file containing your cron jobs.
crontab -e
3)	Add a cron job in the following format, m being minutes, h hours, dom day of month, mon month, and dow day of week:
m h dom mon dow command
4)	So an  example could be: “*/10 * * * * python3 image.py” which will run the image.py script every 10 minutes.
5)	There is a cron job generator that you can use. I’ll include the link here: Crontab.guru - The cron schedule expression editor
