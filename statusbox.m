function statusbox( pool,text )
initial_name=cellstr(get(pool.statusBOX,'String'));
new_name = [initial_name;{text}];
set(pool.statusBOX,'String',new_name)
set(pool.statusBOX,'Value', size(get(pool.statusBOX,'string'), 1))
end