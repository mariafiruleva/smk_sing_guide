## Мотивация

Эта заметка посвящена использованию контейнеризации без root прав с помощью singularity.

Я разберу пару наглядных примеров на базе пайплайнового языка Snakemake (user-friendly, удобный и с хорошей поддержкой сообщества), но вы можете поставить singularity в свою conda environment и использовать её независимо.

Заметка носит практический характер: для знакомства с теорией можно обратиться к разделу *Полезные ресурсы*.

## Подготовка окружения

Клонирование репозитория:

`git clone https://github.com/mariafiruleva/smk_sing_guide`

Активация conda environment:

```
conda create -n smk_sin snakemake=5.19.2 singularity=3.5.3 -c bioconda -c conda-forge
conda activate smk_sin
```

## snakemake + singularity
Код *rules/script_1.smk*:
```
rule plot:
    output: "boxplot.pdf"
    singularity: "docker://joseespinosa/docker-r-ggplot2"
    script: "../scripts/geom_boxplot.R"
```

В поле `output` указано имя файла, который
генерируется скриптом *../scripts/geom_boxplot.R*.
В поле `singularity` указан адрес образа, который будет использован.

Запуск:

```
cd smk_sing_guide
snakemake --use-singularity -j 1 -s rules/script_1.smk
```

Ловится `TypeError` ошибка, описанная здесь:
[github issue](https://github.com/snakemake/snakemake/issues/303).

Для её исправления нужно заменить в 47-ой строке скрипта *singularity.py*
(абсолютный адрес указан в тексте ошибки) 
`if not LooseVersion(v) >= LooseVersion("2.4.1")` на `if not str(LooseVersion(v)) >= str(LooseVersion("2.4.1"))`

После исправления необходимо перезапустить пайплайн.

В результате появился файл *boxplot.pdf*. Также в папке, в которой вы
запускали код, появилась директория *.snakemake* с содержанием:

`auxiliary  conda  conda-archive  locks	log  metadata  scripts	shadow	singularity`

Наверное, важно отметить, что в *.snakemake/singularity* появился файл с
разрешением *simg*, и, например, при перезапуске пайплайна в `--force` режиме
образ не будет стягиваться с докерхаба повторно.

## snakemake + singularity + conda

Код *rules/script_2.smk*:
```
rule geom_hist:
    input: "point.jpg"
    output: "../hist.jpg"
    conda: "../envs/plot.yaml"
    singularity: "docker://continuumio/miniconda3:4.4.10"
    script: "../scripts/geom_hist.R"

rule geom_point:
    output: "point.jpg"
    conda: "../envs/plot.yaml"
    singularity: "docker://continuumio/miniconda3:4.4.10"
    script: "../scripts/geom_point.R"
```

Здесь уже 2 независимых правила:
оба запускают свои скрипты и генерируют свои аутпуты.

Для повышения воспроизводимости Snakemake позволяет комбинировать
singularity + conda, так что в `envs/plot.yaml` файле я указала нужные мне
пакеты и их версии.

Запуск:

`snakemake --j 1 --use-singularity --use-conda -s test2/script.smk`

Если появляется такая ошибка:

`raise ValueError("invalid version number '%s'" % vstring)`

Нужно в скрипте *conda.py* (абсолютный адрес в тексте ошибки) в 437 строке исправить
`version = version.split()[1]` на `version = re.findall('\d.\d.\d', version)[0]`.
И после этого перезапустить скрипт. 

После запуска сначала стягивается образ контейнера, и затем внутри
контейнера устанавливается conda окружение. Поскольку оба правила используют
один и тот же *yaml* файл с конфигурацией, будет установлено только одно
окружение.

## snakemake + singularity + conda + slurm

Запуск предыдущего этапа внутри таски (`-F` = force mode):

`bash task.bash`

## Полезные ресурсы

### Singularity
* [Документация](https://sylabs.io/)
* [Статья](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0177459)
* [Пара слов](https://singularity.lbl.gov/docs-docker) о singularity и docker из оф документации
* [If a Docker exists, why would anyone use singularity?](https://www.quora.com/If-a-Docker-exists-why-would-anyone-use-singularity)
* [github](https://github.com/hpcng/singularity)

### Snakemake:
* [Документация](https://snakemake.readthedocs.io/en/stable/index.html)
* [Статья](https://academic.oup.com/bioinformatics/article/28/19/2520/290322)
* [github](https://github.com/snakemake/snakemake)
* [youtube webinar](https://www.youtube.com/watch?v=hPrXcUUp70Y&t=1206s)

## Контакты
space: @mmfiruleva, telegram: @mfiruleva

Пишите, если возникнут вопросы )
