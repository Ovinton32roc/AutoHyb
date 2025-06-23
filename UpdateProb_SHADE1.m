function [memory_sf,memory_cr,memory_freq,memory_pos,archive,goodF1all,badF1all,goodF2all,badF2all]=UpdateProb_SHADE1(Pop_sel1,pf_sel1,newPopF1,sf_shade,cr_shade,freq_shade,archive,goodF1all,badF1all,goodF2all,badF2all,memory_pos,memory_sf,memory_cr,memory_freq,flag1_shade,flag2_shade,memory_size)
%% improved or not
            dif = abs(pf_sel1- newPopF1)';
            
           %% I == 1: the parent is better; I == 2: the offspring is better
%             I = (pf_sel > children_fitness);
            I = (pf_sel1>  newPopF1)';
            goodCR = cr_shade(I == 1);
            goodF = sf_shade(I == 1);
            goodFreq = freq_shade(I == 1);
            dif_val = dif(I == 1);
            
           %% chnage here also
            %% recored bad too
            badF = sf_shade(I == 0);
            
            %% Change Noor
            if flag1_shade == true
                goodF1 = goodF;
                goodF1all = [goodF1all size(goodF1,1)];
                
                badF1 = badF;
                badF1all = [badF1all size(badF1,1)];
                
                %% Add zero for other one  or add 1 to prevent the case of having NaN
                goodF2all = [goodF2all 1];
                badF2all = [badF2all 1];
                
            end
            if flag2_shade == true
                goodF2 = goodF;
                goodF2all = [goodF2all size(goodF2,1)];
                
                badF2 = badF;
                badF2all = [badF2all size(badF2,1)];
                
                %% Add zero for other one
                goodF1all = [goodF1all 1];
                badF1all = [badF1all 1];
            end
            %%%%%%
            T_Pop_sel1=Pop_sel1';
            T_pf_sel1=pf_sel1';
            archive = updateArchive(archive,  T_Pop_sel1(I == 1, :),  T_pf_sel1(I == 1));    
            
%           [pf_sel1, I] = min([pf_sel1', newPopF1'], [], 2);
%             
%             newpop1 = Pop_sel1;
%             newpop1(:,I == 2) =  newpop(:,I == 2);
            
            num_success_params = numel(goodCR);            
            if num_success_params > 0
                sum_dif = sum(dif_val);
                dif_val = dif_val / sum_dif;
                
                %% for updating the memory of scaling factor
                memory_sf(memory_pos) = (dif_val' * (goodF .^ 2)) / (dif_val' * goodF);
                
                %% for updating the memory of crossover rate
                if max(goodCR) == 0 || memory_cr(memory_pos)  == -1
                    memory_cr(memory_pos)  = -1;
                else
                    memory_cr(memory_pos) = (dif_val' * (goodCR .^ 2)) / (dif_val' * goodCR);
                end
                
                %% for updating the memory of freq
                if max(goodFreq) == 0 || memory_freq(memory_pos)  == -1
                    memory_freq(memory_pos)  = -1;
                else
                    memory_freq(memory_pos) = (dif_val' * (goodFreq .^ 2)) / (dif_val' * goodFreq);
                end
                
                memory_pos = memory_pos + 1;
                if memory_pos > memory_size
                    memory_pos = 1;
                end
            end
