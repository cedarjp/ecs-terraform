# coding=utf-8
# -*- coding:utf-8 -*-

import re
import boto3

PIPELINE_ID = '${pipeline_id}'
PRESET_ID = '1351620000001-200030'  # System preset: HLS 1M
SEGMENT_DURATION = '10'
EXTENSION = ['mp4','mov']

s3 = boto3.client('s3')
transcoder = boto3.client('elastictranscoder', 'ap-northeast-1')


def get_output_bucket_name():
    """PipeLineの設定から出力先のS3 Bucket名を取得して返す
    """
    result = ''
    for pipeline_data in transcoder.list_pipelines()['Pipelines']:
        if PIPELINE_ID == pipeline_data['Id']:
            result = pipeline_data['ContentConfig']['Bucket']
            break
    return result


def is_exists(output_key, res_key, pat):
    """ファイルの存在確認
    """
    # m3u8ファイル
    if '{}.m3u8'.format(output_key) == res_key:
        return True
    # tsファイル
    elif re.match(pat, res_key):
        return True
    return False


def delete_exists_file(output_key, output_bucket_name):
    """すでにファイルが存在する場合は削除する
    """
    pat = re.compile(r"%s[\d+]{5}.ts" % output_key)

    res = s3.list_objects_v2(Prefix=output_key, Bucket=output_bucket_name)
    # 該当ファイルが存在しないときは処理なし
    if not res.get('Contents'):
        return
    for content in res['Contents']:
        if not is_exists(output_key, content['Key'], pat):
            continue
        print(res)
        print(content)
        s3.delete_object(Bucket=res['Name'], Key=content['Key'])
        print('delete: {}'.format(content['Key']))


def lambda_handler(event, context):
    """S3に動画ファイルがアップされたらHLS形式に変換する
    ElasticTranscoderのJOB作成する。
    すでにHLS形式の動画があるときは削除してから再作成する。
    """
    input_key = event['Records'][0]['s3']['object']['key']
    if input_key.split('.')[-1].lower() not in EXTENSION:
        return False
    output_key = '.'.join(input_key.split('.')[:-1])
    output_bucket_name = get_output_bucket_name()

    delete_exists_file(output_key, output_bucket_name)

    transcoder.create_job(
        PipelineId=PIPELINE_ID,
        Input={
            'Key': input_key,
            'FrameRate': 'auto',
            'Resolution': 'auto',
            'AspectRatio': 'auto',
            'Interlaced': 'auto',
            'Container': 'auto',
        },
        Output={
            'Key': output_key,
            'PresetId': PRESET_ID,
            'SegmentDuration': SEGMENT_DURATION,
        },
    )
    return True
