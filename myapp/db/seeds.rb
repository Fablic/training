User.create!(
    [
        name: 'ラクマ太郎',
        email: 'rakuma@rakuten.com',
        password: 'password',
        deleted: false,
    ],
    [
        name: 'ラクマ次郎',
        email: 'rakuma2@rakuten.com',
        password: 'password',
        deleted: false,
    ],
)

Label.create!(
    [
        label: 'Label_A'
        color: '#ffffff'
        bgcolor: '#19902d'
    ],
    [
        label: 'Label_B'
        color: '#ffffff'
        bgcolor: '#f44336'
    ],
)
