% clear all
% close all
% clc

load('Dataset_PostFiltrato_Mano.mat')

mov_ref = 99;
taglio_in = 50;
taglio_out = 50;

RefMov = Dataset_PostFiltrato_Mano{mov_ref};

RefMov = [RefMov(1,taglio_in:(end-taglio_out)); ...
          RefMov(2,taglio_in:(end-taglio_out)); ...
          RefMov(3,taglio_in:(end-taglio_out)); ...
          RefMov(4,taglio_in:(end-taglio_out)); ...
          RefMov(5,taglio_in:(end-taglio_out)); ...
          RefMov(6,taglio_in:(end-taglio_out))];

%% TIME WARPING

tic
ProvaMov = [];
Dataset_Warped = [];
% for i = 1:length(Dataset_PostFiltrato)
for i = 1:length(Dataset_PostFiltrato_Mano)
    ProvaMov = Dataset_PostFiltrato_Mano{i};

    ProvaMov = [ProvaMov(1,taglio_in:(end-taglio_out)); ...
                ProvaMov(2,taglio_in:(end-taglio_out)); ...
                ProvaMov(3,taglio_in:(end-taglio_out)); ...
                ProvaMov(4,taglio_in:(end-taglio_out)); ...
                ProvaMov(5,taglio_in:(end-taglio_out)); ...
                ProvaMov(6,taglio_in:(end-taglio_out))];

    WarpMov = TimeWarping(RefMov, ProvaMov);
    Dataset_Warped{i,1} = WarpMov;
    ProvaMov = [];
    WarpMov = [];
end
toc

%save('Dataset_Warped', 'Dataset_Warped')
%%
% ProvaMov = Dataset_PostFiltrato{19};
% figure(3)
% for i = 1:6
%     subplot(6,1,i)
%     plot(RefMov(i,:),'r')
%     hold on
%     plot(ProvaMov(i,:),'b')
%     hold off
% end

% WarpMov=Dataset_Warped{91};
% figure(4)
% for i = 1:6
%     subplot(6,1,i)
%     plot(RefMov(i,:),'r')
%     hold on
%     plot(WarpMov(i,:),'b')
%     hold off
% end
%% DATI CON WARP A GRUPPI DI 90 MOVIMENTI

% figure(5)
% for i = 1:6
%    subplot(2,3,i)
%    grid on
%    hold on
%    plot(RefMov(i,:), 'r.-')
%    sogg = 2;
%    for j = 90*(sogg-1)+1:90*sogg
%       mov = Dataset_Warped{j,1};
%       plot(mov(i,:), ':')
%    end
%    hold off
% end

%%

% count = 0;
% diff = [];
% for j = 1:2967
%       mov = Dataset_Warped{j,1};
%       if abs(mov(6,end)-mov(6,1)) < 0.61
%           display(j);
%           count = count + 1;
%       else
%           diff(j-count) = mov(6,end)-mov(6,1);
%       end
% end

% max(abs(diff))
% min(abs(diff))
% mean(abs(diff))

%%
% figure;
% for j = 1 : size(Dataset_Warped,1)
%     hold on;
%         tmp = Dataset_Warped{j};
%         subplot(2,3,1);hold on; plot(tmp(1,:))
%         subplot(2,3,2);hold on; plot(tmp(2,:))
%         subplot(2,3,3);hold on; plot(tmp(3,:))
%         subplot(2,3,4);hold on; plot(tmp(4,:))
%         subplot(2,3,5);hold on; plot(tmp(5,:))
%         subplot(2,3,6);hold on; plot(tmp(6,:))
% end
% %%

% j = 457
% WarpMov=Dataset_Warped{j};
% Orig=Dataset_PostFiltrato{j};
% Prefilt=Dataset_Posestimate{j};
% figure
% for i = 1:6
%     subplot(6,1,i)
%     %plot(RefMov(i,:),'r')
%     hold on
%     %plot(WarpMov(i,:),'b')
%     plot(Orig(i,:),'g')
%     plot(Prefilt(i,:),'m')
%     hold off
% end