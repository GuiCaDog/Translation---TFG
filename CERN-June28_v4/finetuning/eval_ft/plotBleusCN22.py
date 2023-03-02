import matplotlib.pyplot as plt

# create data
nu = [50, 500, 1000, 1500, 2000, 2500, 5000]
bl100 = [38.8, 42.1, 42.6, 42.9, 42.8, 42.5, 42.2]

textFile="CN22__bleu"

fig1, ax1 = plt.subplots()
ax1.plot(nu, bl100,"-_", label = "k=100", linewidth=0.8)
#ax1.set_xscale('log')
ax1.set_xticks(nu)
ax1.set_xticklabels(["0","500","1000","1500","2000","2500","5000"])
ax1.set_xlabel("num_updates")
ax1.set_ylabel(textFile)
plt.legend()
plt.savefig(textFile+'.png')
