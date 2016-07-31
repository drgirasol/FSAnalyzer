function pointselectCALC
pool.plot=get(gcf,'userdata');
cp=get(gca,'currentpoint');%koordinaten des angeklickten punktes
y=abs(get(pool.plot.dD,'ydata')-cp(2,2));
x=abs(get(pool.plot.dD,'xdata')-cp(1,1));
Y=get(pool.plot.dD,'ydata')';
X=get(pool.plot.dD,'xdata')';

% debug_clicked_x_pos = X(find(min(x)==x))
% debug_clicked_y_pos = Y(find(min(x)==x))

range = round(pool.plot.dPointsperBase(pool.plot.selC)) * 1.5;
wobbleY = Y(X(find(min(x)==x))-range:...
    X(find(min(x)==x))+range);
wobbleX = X(X(find(min(x)==x))-range:...
    X(find(min(x)==x))+range);
selX = wobbleX(find(wobbleY==max(wobbleY)));
selY = wobbleY(find(wobbleY==max(wobbleY)));

% debug_clickcorr_x_pos = selX
% debug_clickcorr_y_pos = selY

if isempty(find(pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(:,1)==selX))
    Ypks=get(pool.plot.Pks,'ydata')';
    Xpks=get(pool.plot.Pks,'xdata')';
    
    tmp = abs(Xpks - selX);
    [idx idx] = min(tmp);
    closest = Xpks(idx);
    if ~pool.plot.flagC %marker
        if closest<selX
            c=0;
            for i=1:1:size(Xpks,1)
                if i==idx
                    c=c+1;
                    replotPks(c,1) = Xpks(i);
                    replotPks(c,2) = Ypks(i);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(i,:);
                    c=c+1;
                    replotPks(c,1) = selX;
                    replotPks(c,2) = selY;
                    corrFlagTMP(c,1) = selX;
                    corrFlagTMP(c,2) = selY;
                    corrFlagTMP(c,3) = 0;
                else
                    c=c+1;
                    replotPks(c,1) = Xpks(i);
                    replotPks(c,2) = Ypks(i);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(i,:);
                end
            end
        else
            c=size(Xpks,1)+1;
            for i=size(Xpks,1)+1:-1:2
                if i==idx
                    replotPks(c,1) = selX;
                    replotPks(c,2) = selY;
                    corrFlagTMP(c,1) = selX;
                    corrFlagTMP(c,2) = selY;
                    corrFlagTMP(c,3) = 0;
                    c=c-1;
                    replotPks(c,1) = Xpks(i-1);
                    replotPks(c,2) = Ypks(i-1);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(i-1,:);
                    c=c-1;
                else
                    replotPks(c,1) = Xpks(i-1);
                    replotPks(c,2) = Ypks(i-1);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(i-1,:);
                    c=c-1;
                end
            end
        end
        pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)} = corrFlagTMP;
    else %dye
        if closest<selX
            c=0;
            for i=1:1:size(Xpks,1)
                if i==idx
                    c=c+1;
                    replotPks(c,1) = Xpks(i);
                    replotPks(c,2) = Ypks(i);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,pool.plot.selC}(i,:);
                    c=c+1;
                    replotPks(c,1) = selX;
                    replotPks(c,2) = selY;
                    corrFlagTMP(c,1) = selX;
                    corrFlagTMP(c,2) = selY;
                    corrFlagTMP(c,3) = 0;
                else
                    c=c+1;
                    replotPks(c,1) = Xpks(i);
                    replotPks(c,2) = Ypks(i);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,pool.plot.selC}(i,:);
                end
            end
        else
            c=size(Xpks,1)+1;
            for i=size(Xpks,1)+1:-1:2
                if i==idx
                    replotPks(c,1) = selX;
                    replotPks(c,2) = selY;
                    corrFlagTMP(c,1) = selX;
                    corrFlagTMP(c,2) = selY;
                    corrFlagTMP(c,3) = 0;
                    c=c-1;
                    replotPks(c,1) = Xpks(i-1);
                    replotPks(c,2) = Ypks(i-1);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,pool.plot.selC}(i-1,:);
                    c=c-1;
                else
                    replotPks(c,1) = Xpks(i-1);
                    replotPks(c,2) = Ypks(i-1);
                    corrFlagTMP(c,:) = pool.plot.corrFlag{pool.plot.selF,pool.plot.selC}(i-1,:);
                    c=c-1;
                end
            end
        end
        pool.plot.corrFlag{pool.plot.selF,pool.plot.selC} = corrFlagTMP;
    end
end
delete(pool.plot.Pks)
hold on;
if ~pool.plot.flagC
    pool.ladder = pool.plot.ladder;
    pool.corrFlag = pool.plot.corrFlag;
    pool.selF = pool.plot.selF;
    delete(pool.plot.tags)
    pool.ladder = pool.plot.ladder;
    pool.corrFlag = pool.plot.corrFlag;
    pool.selF = pool.plot.selF;
    [ pool ] = calcTAGpos( pool );
    for label=1:1:size(pool.sTAGpos,1)
        tags(label) = text(pool.sTAGpos(label),pool.sTAGpos(label)-pool.sTAGpos(label)-100,num2str(pool.ladder(label)),'fontsize',5);
        set(tags(label),'Clipping','on');
    end
    pool.plot.tags = tags;
end
pool.plot.Pks = plot(replotPks(:,1),replotPks(:,2),'ro');
if ~pool.plot.flagC
    delete(pool.plot.pnote);
    if size(pool.plot.ladder,2)==(size(pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)},1)-sum(pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(:,3)))
        pool.plot.pnote = annotation('textbox',...
            [0.75 0.8 0.152 0.05],...
            'String',strcat('Peaks found:',{' '},num2str((size(pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)},1)-sum(pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(:,3))))),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','middle',...
            'FontSize',14,...
            'FontName','Arial',...
            'EdgeColor',[0 0 0],...
            'LineWidth',2,...
            'BackgroundColor',[0.9 0.9 0.9],...
            'FitBoxToText','on',...
            'Tag',strcat(num2str(pool.plot.selF),'.','markerpinfo'),...
            'Color',[0.2 0.6 0.2]);%green
    else
        pool.plot.pnote = annotation('textbox',...
            [0.75 0.8 0.152 0.05],...
            'String',strcat('Peaks found:',{' '},num2str((size(pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)},1)-sum(pool.plot.corrFlag{pool.plot.selF,size(pool.plot.corrFlag,2)}(:,3))))),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','middle',...
            'FontSize',14,...
            'FontName','Arial',...
            'EdgeColor',[0 0 0],...
            'LineWidth',2,...
            'BackgroundColor',[0.9 0.9 0.9],...
            'FitBoxToText','on',...
            'Tag',strcat(num2str(pool.plot.selF),'.','markerpinfo'),...
            'Color',[0.85 0.20 0]);%red
    end
end
hold off;
uistack(pool.plot.Pks,'top');
set(gcf,'userdata',pool.plot);
end