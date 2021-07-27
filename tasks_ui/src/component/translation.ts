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
            ok: 'OK',
            cancel: 'Cancel',
          },
        },
        ja: {
          translation: {
            task_name: 'タイトル',
            task_description: '説明',
            due_date: '期限',
            ok: '確定',
            cancel: 'キャンセル',
          },
        },
      },
      fallbackLng: 'en',
    })

  return i18n
}
