clear;
rng(99);
v = VideoWriter('perceptron','MPEG-4'); v.FrameRate = 8;
open(v);
F(1) = struct('cdata',[],'colormap',[]);

Xp = randn(2,200)+[1;1];
Xq = randn(2,200)+[-1;-1];

Xp = [Xp;ones(1,200)];
Xq = [Xq;ones(1,200)];

fig = figure;
xs = sym('xs',[2,1],'real');

w = randn(3,1);
cc = 1;
for it = 1:10
    eta = 1;
    for i = 1:200
        updated = false;
        etai = eta/it;
        if w'*Xp(:,i) < 0
            w = w + etai* Xp(:,i)/(norm(Xp(:,i))^2);
            updated = true;
        end
        
        if w'*Xq(:,i) > 0
            w = w - etai* Xq(:,i)/(norm(Xq(:,i))^2);
            updated = true;
        end
        
        w = w ./ norm(w)
        
        if updated
            clf
            scatter(Xp(1,:),Xp(2,:),'linewidth',2);
            hold on;
            title("a perceptron classifier")
            scatter(Xq(1,:),Xq(2,:),'linewidth',2);
%             xmarks = linspace(-6,6,100);
%             y = (-w(end) - w(1)*xmarks)/w(2);
%             plot(xmarks,y)

            h = fcontour(w'*[xs;ones(1,size(xs,2))]);
            h.LevelList = [0];
            h.LineWidth = 2;
            axis([-6,6,-6,6]);
            grid on
            text(-6,5.5,sprintf('Update: %d',cc),'Color','r','FontSize',22)
            drawnow;
            
            frame = getframe(gcf);
            writeVideo(v,frame);
            cc = cc + 1;
        end
    end
end

close(v);
