---
date: '{{ .Date }}'
draft: true
title: '{{ replace (path.Base (path.Dir .Name)) "-" " " | title }}'
tags: []
categories: []
description: ''
---
