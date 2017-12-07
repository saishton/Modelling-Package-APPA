h1 = openfig('model-2c graphics/Active Nodes_indiv.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('model-2c graphics/Activity Potential_indiv.fig','reuse');
ax2 = gca;
h3 = openfig('model-2c graphics/Number of Components_indiv.fig','reuse'); % open figure
ax3 = gca; % get handle to axes of figure
h4 = openfig('model-2c graphics/Clustering Coefficient_indiv.fig','reuse');
ax4 = gca;

% test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
s2 = subplot(2,2,2);
s3 = subplot(2,2,3);
s4 = subplot(2,2,4);
fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig4,s4);