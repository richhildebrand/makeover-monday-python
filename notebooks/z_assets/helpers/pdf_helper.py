import matplotlib
from wand.image import Image  

def save_and_show_pdf(file_name, fig, plt):
    save_pdf(file_name, fig, plt)
    return show_pdf(file_name)

def save_pdf(file_name, fig, plt, ):
    plt.savefig(file_name)
    matplotlib.pyplot.close(fig) #do not draw

def show_pdf(file_name):
    imageFromPdf = Image(filename=file_name)  
    pages = len(imageFromPdf.sequence)  

    image = Image(  
      width=imageFromPdf.width,  
      height=imageFromPdf.height * pages  
    )  
    for i in range(pages):  
      image.composite(  
      imageFromPdf.sequence[i],  
      top=imageFromPdf.height * i,  
      left=0  
    )  
    image.format="png"  
    return image