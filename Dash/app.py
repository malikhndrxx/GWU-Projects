import dash
import dash_table
import dash_core_components as dcc
import dash_html_components as html
import dash_bootstrap_components as dbc
from dash.dependencies import Input, Output, State
import plotly.graph_objs as go
import plotly.express as px
import pandas as pd
import math


external_stylesheets =['https://codepen.io/chriddyp/pen/bWLwgP.css', dbc.themes.BOOTSTRAP]

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)


df = pd.read_csv("NBA_data.csv")

df['Salary '] = df['Salary'].str.replace(',' , '')
df['Salary '] = df['Salary '].str.replace('$' , '')
df['Salary '] = df['Salary '].apply(pd.to_numeric)

#Stacked Graph Variables
trace1 = go.Bar(
    x = df['Name'],
    y = df['FGM'],
    name = 'FGM'
)

trace2 = go.Bar(
    x = df['Name'],
    y = df['3PM'],
    name = '3PM'
)

app_template = go.layout.Template(
	layout = go.Layout(title_font = dict(color = 'White'),
				plot_bgcolor = '#1F2132',
           		paper_bgcolor = '#1F2132',
            	legend = {'bgcolor':'LightSteelBlue',
            				'bordercolor':'Black',
            				'borderwidth':2,
            				'font':dict(color = 'Black')},
            	xaxis = dict(color = 'White'),
            	yaxis = dict(color = 'White'),
        )
    )
				
#App
app.layout = html.Div(
    style={'backgroundColor': '#1F2132', 'color':'white'},
    children = [
        html.H1(children = 'NBA Dashboard',
                style = {
                	'fontSize':40,
                    'textAlign':'left',
                    'backgroundColor':'LightSteelBlue',
                    'color':'#1F2132',
                    'padding-left':'50px'}),
        #Row 1
        html.Div(
            className = 'row',
            children = [
                html.Div(
                    className = 'col1',
                    children = [
                        html.H3(children = "Select X-Axis Variable",
                                style = {'textAlign':'center'}
                        ),
                        dcc.Dropdown(
                            id = "x-axis",
                            options = [{'label':i, 'value':i} for i in df.columns[2:16]],
                            value = df.columns[2],
                            clearable=False,
                            style = {
                                'width':'350px',
                                'fontSize':'20px',
                                'padding-left':'50px',
                                'textAlign':'center',
                                'color':'black'}
                        ),
                    ], style = {'width': '30%',
                                'display':'inline-block',
                                'padding-right':'30px',
                                }
                ),

                html.Div(
                    className = "col2",
                    children = [
                        html.H2(children = 'Salary Plot',
                        style = {'textAlign':'center'}),

                        dcc.Graph(
                            id = "salary-graph",
                        )
                    ], style = {'width':'70%',
                                'display':'inline-block',
                                'padding-right':'20px'}
                ),
            ], style = {'padding-top':'20px',
                        'width': '100%',
                        'display': 'flex',
                        'align-items': 'center',
                        'justify-content': 'center',}
        ),

        #Row 2
        html.Div(
            className = 'row',
            children = [
                html.Div(
                    className = 'col1',
                    children = [
                        dcc.Graph(id = 'stacked-plot',
                                  figure = go.Figure(data = [trace1, trace2],
                                    layout = go.Layout(barmode='stack',
                                                    title = {'text':'Player Shots Made Per Game',
                                                    'y': 0.9,
                                                    'x':0.5,
                                                    'xanchor':'center',
                                                    'yanchor':'top',},
                                                    xaxis = dict(
                                                        color = 'white'
                                                    ),
                                                    yaxis = dict(
                                                        title = 'Made Shots',
                                                        #gridcolor = 'white',
                                                        #gridwidth = 2,
                                                        color = 'white'
                                                    ),
                                                    plot_bgcolor = '#1F2132',
           											paper_bgcolor = '#1F2132',
            										legend = {'bgcolor':'LightSteelBlue',
            													'bordercolor':'Black',
            													'borderwidth':2,
            													'font':dict(color = 'Black')
            													},
            										font = dict(color = 'white')
                                                )),
                                style = {'width': '45%', 'padding-right':'30px'}
                                ),
                        dcc.Graph(id = 'bubble-chart',
                                  figure = px.scatter(df, template = app_template,
                                            title = {'text':'Player\'s Salary Comparison',
                                            'y': 0.9,
                                            'x':0.5,
                                            'xanchor':'center',
                                            'yanchor':'top'},
                                            x = df['Points Per Game'],
                                            y = df['Salary '],
                                            color = 'Name',
                                            size = df['Salary ']),
                                    style = {'width':'45%','padding-left':'30px'},
                                 ),

                    ], style = {'padding-top':'50px',
                                'width': '100%',
                                'display': 'flex',
                                'align-items': 'center',
                                'justify-content': 'center',}
                ),
            ]
        ),

        #Row 3
        html.Div(
            className = 'row',
            children = [
                html.Div(
                    className = 'col1',
                    children = [
                        html.H3(children = 'Select Player One',
                        style = {'padding-top':'50px',}),
                        dcc.Dropdown(
                            id='player_1',
                            clearable=False,
                            options = [{'label':i, 'value':i} for i in df.Name],
                            value = df.Name[0],
                            style = {
                                'width':'350px',
                                'fontSize':'20px',
                                'padding-left':'80px',
                                'textAlign':'center',
                                'color':'black'}
                        ),

                        html.H3(children = 'Select Player Two',
                        style = {'display':'inline-block',
                                 'padding-top':'50px'}),
                        dcc.Dropdown(
                            id = 'player_2',
                            clearable=False,
                            options = [{'label':i, 'value':i} for i in df.Name],
                            value = df.Name[1],
                            style = {
                                'width':'350px',
                                'fontSize':'20px',
                                'padding-left':'80px',
                                'textAlign':'center',
                                'color':'black'}
                        )
                    ], style = {'width':'30%',
                                'textAlign':'center',}
                ),
                html.Div(
                    className = 'col2',
                    children = [
                        dcc.Graph(id = 'comparison-graph')
                    ], style = {'padding-top':'50px',
                                'width':'70%',
                                'textAlign':'center'}
                ),
            ],
            style = {'padding-top':'50px',
                        'width': '100%',
                        'display': 'flex',
                        'align-items': 'center',
                        'justify-content': 'center',}
        ),

        #Show Table
        html.Div(
            className = 'NBA-Data-Table',
            children = [
                html.H2(children = 'NBA Player Stats',
                        style = {'textAlign':'center',
                                 'padding-top':'50px'}),
                dash_table.DataTable(
                    id = 'data_table',
                    columns = [{'name':i,'id':i, 'editable':(i=='Name' or i == 'Salary')} for i in df.columns[0:18]],
                    data = df.to_dict('records'),
                    style_cell = {
                        'textAlign':'center',
                        'color':'black'
                    },
                    style_data_conditional = [{
                        'if': {'row_index':'odd'},
                        'backgroundColor':'rgb(248,248,248)',
                        'if':{'column_editable':True},
                        'backgroundColor':'rgb(230,230,230)',
                        'fontWeight':'bold'
                    }],
                    style_header={
                        'backgroundColor':'rgb(230,230,230)',
                        'fontWeight':'bold',
                        'color':'black'
                    },
                    style_table={
                        'maxHeight':'300px',
                        'overflowY':'scroll',
                    },
                )
            ]
        ),
    ],
)

#Callbarck for scatter plot
@app.callback(
    Output(component_id='salary-graph', component_property='figure'),
    [Input(component_id='x-axis',component_property='value')],
)

#Updates Scatter Plot
def update_scatter(x_value):
    figure = {
        'data': [
            go.Scatter(
                x = df[df['Name'] == i][x_value],
                y = df[df['Name'] == i]['Salary '],
                text = df[df['Name'] == i]['Name'],
                mode = 'markers',
                opacity = 0.8,
                marker = {
                    'size':15,
                    'line': {'width':0.5, 'color':'orange'}
                },
                name = i
            ) for i in df.Name.unique()
        ],
        'layout': go.Layout(
            xaxis = {'type':'log', 'title':x_value, 'color':'white'},
            yaxis = {'title':'Salary', 'color':'white'},
            margin = {'l': 50, 'b': 40, 't': 10, 'r': 10},
            hovermode = 'closest',
            plot_bgcolor = '#1F2132',
            paper_bgcolor = '#1F2132',
            legend = {'bgcolor':'LightSteelBlue',
            'bordercolor':'Black','borderwidth':2,}
        )
    }

    return figure

@app.callback(
    Output(component_id='comparison-graph', component_property = 'figure'),
    [Input(component_id='player_1', component_property = 'value'),
    Input(component_id='player_2',component_property = 'value')]
)

def update_comparison(player_1,player_2):
    dff = pd.DataFrame()
    dff = dff.append(df[df['Name'] == player_1])
    dff = dff.append(df[df['Name'] == player_2])
    dff.set_index("Name", inplace = True)

    stats = ['MPG', 'PPG','Assists', 'Rebounds', 'Plus/Minus']

    stats1 = []
    stats1.append(dff.loc[player_1,'Minutes Per Game'])
    stats1.append(dff.loc[player_1, 'Points Per Game'])
    stats1.append(dff.loc[player_1,'Assists'])
    stats1.append(dff.loc[player_1, 'Rebounds'])
    stats1.append(dff.loc[player_1, 'Plus/Minus'])

    stats2 = []
    stats2.append(dff.loc[player_2,'Minutes Per Game'])
    stats2.append(dff.loc[player_2, 'Points Per Game'])
    stats2.append(dff.loc[player_2,'Assists'])
    stats2.append(dff.loc[player_2, 'Rebounds'])
    stats2.append(dff.loc[player_2, 'Plus/Minus'])

    data1 = go.Bar(name = player_1.title(), x = stats1, y = stats, orientation = 'h')
    data2 = go.Bar(name = player_2.title(), x = stats2, y = stats, orientation = 'h')

    return {
        'data': [data1,data2],
        'layout': go.Layout(title = 'Comparing {player1} and {player2}'.format(player1 = player_1, player2 = player_2),
                          		plot_bgcolor = '#1F2132',
                          		paper_bgcolor = '#1F2132',
                          		legend = {'bgcolor':'LightSteelBlue',
                          		'bordercolor':'Black',
                          		'borderwidth':2,
                          		'font':dict(color = 'Black')},
                          		font = dict(color = 'white') 
                          	)
        }

#Remove the name selected as player 2 from dropdown for player 1
@app.callback(
    Output('player_1','options'),
    [Input('player_2', 'value')]
)

def update_player_1(player2):
    names  = []
    for name in df.Name:
        if name != player2:
            names.append(name)

    options = [{'label':i, 'value':i} for i in names]

    return options

#Remove the name selected as player 1 from dropdown for player 2
@app.callback(
    Output('player_2','options'),
    [Input('player_1', 'value')]
)

def update_player_2(player1):
    names  = []
    for name in df.Name:
        if name != player1:
            names.append(name)

    options = [{'label':i, 'value':i} for i in names]

    return options

if __name__ == '__main__':
    app.run_server(debug=True)
