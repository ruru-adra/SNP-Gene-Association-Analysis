#bonferroni threshold
-log10(0.05/65)= 3.113943
p>3.11

-log10(0.05/47)=2.973128
p>2.97

adj_glm<- glm %>% 
  select(snpID, Chr, Pos, p) %>%
  transmute(snpID, Chr, Pos, p,
            p_bonf=p.adjust(glm$p, "bonferroni"),
            p_fdr=p.adjust(glm$p, "fdr"))

fdr_glm005<- filter(adj_glm, p_fdr < 0.05)
fdr_glm001<- filter(adj_glm, p_fdr < 0.01)
bonf_glm005<- filter(adj_glm, p_fdr < 0.05)
bonf_glm001<- filter(adj_glm, p_fdr < 0.01)
bonf_glm311<- filter(adj_glm, p_bonf > 3.11)

adj_mlm<- mlm %>% 
  select(snpID, Chr, Pos, p) %>%
  transmute(snpID, Chr, Pos, p,
            p_bonf=p.adjust(mlm$p, "bonferroni"),
            p_fdr=p.adjust(mlm$p, "fdr"))