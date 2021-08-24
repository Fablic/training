import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'
import LanguageDetector from 'i18next-browser-languagedetector'

export const initI18n = () => {
  i18n
    .use(initReactI18next)
    .use(LanguageDetector)
    .init({
      resources: {
        en: {
          translation: {
            task_name: 'Name',
            task_description: 'Description',
            due_date: 'Due date',
            labels: 'Labels',
            ok: 'OK',
            cancel: 'Cancel',
            order: {
              createdAt: 'Created at',
              dueDate: 'Due date (asc)',
              dueDateDesc: 'Due date (desc)',
            },
            status: {
              open: 'Open',
              inProgress: 'In progress',
              close: 'Close',
            },
            search: 'Search keyword',
          },
        },
        ja: {
          translation: {
            task_name: 'タイトル',
            task_description: '説明',
            due_date: '期限',
            labels: 'ラベル',
            ok: '確定',
            cancel: 'キャンセル',
            order: {
              createdAt: '作成日時',
              dueDate: '期限(昇順)',
              dueDateDesc: '期限(降順)',
            },
            status: {
              open: '未着手',
              inProgress: '着手中',
              close: '完了',
            },
            search: '検索語',
          },
        },
      },
      fallbackLng: 'en',
    })

  return i18n
}
