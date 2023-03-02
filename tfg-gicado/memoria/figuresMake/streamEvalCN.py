import matplotlib.pyplot as plt

xtics = [1,3,6,9,12,15]
ytics = [15,20,25,30,35,40,45]
bleu = [24.9, 29.9, 35.7, 37.0, 37.3, 37.4]
al = [2.1, 3.2, 5.6, 8.2, 10.9, 13.3]
dal = [2.7, 3.9, 6.5, 9.2, 11.7, 14.0]

#ap = [0.6, 0.7, 0.8, 0.9, 0.9, 0.9]
fig1, ax1 = plt.subplots()

ax1.axis([0,16,15,45])
ax1.plot(al, bleu,"-o", label = "AL", linewidth=1)
ax1.plot(dal, bleu,"-o", label = "DAL", linewidth=1)
ax1.axhline(y = 38.6, color = 'c', linestyle = ':')


ax1.set_xticks(xtics)
ax1.set_yticks(ytics)
ax1.text(12.4, 39.2,'V4-Offline', fontsize=15)
ax1.text(0, 43.5,'BLEU(CN21)', fontsize=15)
ax1.text(13.2, 15.2,'Latency', fontsize=15)
ax1.text(6, 27,'AL', fontsize=15)
ax1.text(2.5, 32.5,'DAL', fontsize=15)

plt.grid(True)
plt.savefig('../resources/onlineresCN.png')
#plt.show()
