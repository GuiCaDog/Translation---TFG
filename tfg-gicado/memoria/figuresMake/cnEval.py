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
ax1.plot(nu, bl100,"-o", label = "%=100", linewidth=0.8)
ax1.plot(nu, bl90,"-o", label = "%=90", linewidth=0.8)
ax1.plot(nu, bl70,"-o", label = "%=70", linewidth=0.8)
ax1.plot(nu, bl50,"-o", label = "%=50", linewidth=0.8)
ax1.plot(nu, blbt,"-o", linewidth=0.8)
ax1.set_xscale('log')
ax1.set_xticks(nu)

ax1.axis([45,5500,34,42.5])
ax1.set_xticklabels(["0","100","200","500","1000","2000","5000"])
ax1.text(47, 42,'BLEU(CN21)', fontsize=15)
ax1.text(1950, 34.05, '#Updates', fontsize=15)
ax1.text(500, 36.5, 'BT_FT', fontsize=15)
ax1.text(100, 41, 'CN_FT', fontsize=15)
#ax1.set_xlabel("num_updates")
#ax1.set_ylabel(textFile)
plt.legend(loc=3)
plt.grid(True)
plt.savefig("../resources/CN21_bleu.png")


#plt.show()
