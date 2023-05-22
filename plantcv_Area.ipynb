#Load the packages you'll need
from plantcv import plantcv as pcv
import os
import numpy as np

#Set some variables. Most of these won't change between notebooks-- the main thing you'll want to edit will be the path to
#your image (under "self.image"). If you want your output to be sent to a folder other than the one your notebook is
#currently in, you can enter the file path under self.outdir.
class options:
    def __init__(self):        
        self.image = "C:/Users/ekine/PlantCV_images/brassica_wave1/rec/rec_wo82_frz_r567.jpg" # Change this for every image
        self.debug = "plot"
        self.writeimg = False
        self.result = ""
        self.outdir = ""
args = options()
pcv.params.debug_outdir = args.outdir
pcv.params.debug = args.debug
pcv.params.debug = None
img, imgpath, imgname = pcv.readimage(args.image)
#Convert to grayscale through the 'b' channel of the lab colorspace
b_img = pcv.rgb2gray_lab(rgb_img=img, channel='b')
#Use a binary threshold to convert to a mask. The number you enter under "threshold" will determine which pixels are kept
#(converted to white in the mask). Setting "object_type" to "light" will make it so any pixel with a value higher than
#the provided threshold will be converted to white, while "dark" converts anything lower than the threshold.
bin_img = pcv.threshold.binary(gray_img=b_img, threshold=145, max_value=255, object_type="light")
#this step gets rid of some of the white specks in the background 
fill_mask = pcv.fill(bin_img=bin_img, size=50)
filled_holes = pcv.fill_holes(bin_img=fill_mask)
#Apply your mask over the image to make sure you're not picking up any background along with the plants
application_test = pcv.apply_mask(img=img, mask=fill_mask, mask_color="white")
background_mask = pcv.invert(fill_mask)
background_material = pcv.apply_mask(img=img, mask=background_mask, mask_color="white")
pcv.params.debug = "plot"
#This step uses the plant mask you provide to find the plant pixels within your RGB image
obj_cnt, obj_h = pcv.find_objects(img=img, mask=fill_mask)

#Draw regions of interest around where the plants are located. The size and location of the ROIs will depend on the
#coordinates and radius you provide. It's fine if the ROI doesn't completely surround your plants-- just keep in mind that
#there should only be material from one plant within each ROI. Also, any pixels that aren't continuous with the pixels 
#inside the ROI won't be picked up, so if there are any "breaks" in your plant mask you'll have to position your ROI 
#carefully.
multi_cnt, multi_h = pcv.roi.multi(img=fill_mask, coord=[(3000,2100),(1500,1900),(2500,1100)], radius=400)


##### Size analysis of all the plants in the image
#Set up a variable called plant_id that describes how many ROIs you made. We'll need this for the next step.
plant_id = range(0,len(multi_cnt))
print(plant_id)

#Use a for loop to abalyze every plant in the image. The loop will go through and repeat the analysis steps above for each
#ROI number you provide it, combining the output from each round to return one output file/image with information for every
#plant.

#Create a copy of your image that you can add the visualization of the output to
img_copy = np.copy(img)
pcv.params.debug = None #turn off debug so it won't print the output of every step as it runs

for i in range(0, len(multi_cnt)):
    roi = multi_cnt[i]
    hierarchy = multi_h[i]
    id_label = plant_id[i]
    # Find objects
    filtered_contours, filtered_hierarchy, filtered_mask, filtered_area = pcv.roi_objects(
        img=img, roi_type="partial", roi_contour=roi, roi_hierarchy=hierarchy, object_contour=obj_cnt, 
        obj_hierarchy=obj_h)

    if filtered_area > 0:
        # Combine objects together in each plant     
        plant_contour, plant_mask = pcv.object_composition(img=img, contours=filtered_contours, hierarchy=filtered_hierarchy)        
        # Analyze the shape of each plant 
        img_copy = pcv.analyze_object(img=img_copy, obj=plant_contour, mask=plant_mask, label=id_label)

#Turn image plotting back on
pcv.params.debug = "plot"

pcv.plot_image(img_copy)
#Save the numerical output of the analyze_object function.
pcv.outputs.save_results(filename=os.path.join(args.outdir, imgpath + "/results/" + imgname[:-4] + ".csv"), outformat="csv")


