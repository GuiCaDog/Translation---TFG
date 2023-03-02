import matplotlib
import matplotlib.pyplot as plt

# create data
nu = [50,100,200,500,1000,2000,5000]
bl100 = [38.3, 40.0, 40.4, 41.3, 41.7, 42.0, 41.90]
bl90 = [38.3, 40.0, 40.5, 41.3, 41.5, 41.5, 41.7]
bl70 = [38.3, 39.8, 40.3, 40.8, 41.2, 41.0, 40.8]
bl50 = [38.3, 39.7, 40.0, 40.5, 40.3, 39.9, 38.8]
blbt = [38.3, 37.3, 37.4, 37.2, 37.1, 36.1, 34.6]

textFile="CN21_bleu"
# plot lines
fig1, ax1 = plt.subplots()
ax1.plot(nu, bl100,"-_", label = "k=100", linewidth=0.8)
ax1.plot(nu, bl90,"-_", label = "k=90", linewidth=0.8)
ax1.plot(nu, bl70,"-_", label = "k=70", linewidth=0.8)
ax1.plot(nu, bl50,"-_", label = "k=50", linewidth=0.8)
ax1.plot(nu, blbt,"-_", label = "bt_ft", linewidth=0.8)
ax1.set_xscale('log')
ax1.set_xticks(nu)
ax1.set_xticklabels(["0","100","200","500","1000","2000","5000"])
ax1.set_xlabel("num_updates")
ax1.set_ylabel(textFile)
plt.legend()
plt.savefig(textFile+'.png')
#plt.show()
