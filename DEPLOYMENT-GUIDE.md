# 🚀 Guide de Déploiement Rapide SwissPark

## ⚡ **Déploiement en 5 minutes**

### Option 1: Vercel (Recommandé - Gratuit)

1. **Allez sur [vercel.com](https://vercel.com)**
2. **Créez un compte** avec GitHub
3. **Cliquez "New Project"**
4. **Importez votre repository** ou glissez-déposez le dossier `web/`
5. **Configurez votre domaine** `suissepark.ch`
6. **Cliquez "Deploy"**

✅ **Votre site est en ligne !**

---

### Option 2: Netlify (Gratuit)

1. **Allez sur [netlify.com](https://netlify.com)**
2. **Créez un compte**
3. **Glissez-déposez** le dossier `web/` sur la zone de déploiement
4. **Attendez le déploiement**
5. **Cliquez "Domain settings"** et ajoutez `suissepark.ch`

✅ **Votre site est en ligne !**

---

### Option 3: GitHub Pages (Gratuit)

1. **Créez un repository** `swisspark-web` sur GitHub
2. **Uploadez** tous les fichiers du dossier `web/`
3. **Allez dans Settings > Pages**
4. **Source: Deploy from a branch**
5. **Branch: main, folder: / (root)**
6. **Sauvegardez**

✅ **Votre site est en ligne !**

---

## 🔧 **Configuration DNS**

Une fois déployé, configurez votre domaine :

```
Type    Nom    Valeur
A       @      [IP de votre hébergement]
CNAME   www    suissepark.ch
```

**Vercel/Netlify** vous donneront les bonnes valeurs DNS.

---

## 📱 **Test de votre site**

1. **Ouvrez** `https://suissepark.ch`
2. **Testez** sur mobile et desktop
3. **Vérifiez** que tout fonctionne
4. **Testez** les performances avec [Lighthouse](https://developers.google.com/web/tools/lighthouse)

---

## 🎯 **Prochaines étapes**

1. **Ajoutez Google Analytics**
2. **Configurez HTTPS** (automatique sur Vercel/Netlify)
3. **Testez** sur différents appareils
4. **Optimisez** les images et performances
5. **Intégrez** avec votre app mobile

---

## 🆘 **Problèmes courants**

### Le site ne se charge pas
- Vérifiez la configuration DNS
- Attendez 24-48h pour la propagation DNS
- Vérifiez que le déploiement est terminé

### Erreur 404
- Vérifiez que tous les fichiers sont uploadés
- Vérifiez la configuration des routes

### Site lent
- Optimisez les images
- Activez la compression Gzip
- Utilisez un CDN

---

## 📞 **Support**

- **Vercel**: [vercel.com/support](https://vercel.com/support)
- **Netlify**: [netlify.com/support](https://netlify.com/support)
- **GitHub**: [github.com/support](https://github.com/support)

---

**🎉 Félicitations ! Votre site SwissPark est maintenant en ligne sur suissepark.ch**
