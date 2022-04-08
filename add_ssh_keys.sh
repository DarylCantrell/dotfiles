#! /bin/bash

mysql -D github_development << 'EOF'
SELECT id INTO @mona_id FROM users WHERE login = 'monalisa';
SELECT id INTO @collab_id FROM users WHERE login = 'collaborator';

INSERT INTO public_keys
	(user_id,
	`key`,
	username,
	title,
	created_at,
	updated_at,
	verified_at,
	creator_id,
	verifier_id,
	created_by,
	read_only,
	fingerprint_sha256)
VALUES (
	@mona_id,
	concat(
		'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOHuHHGKPF1dQj6flLCRYjQ/zsBdjY0+NNcD+JF2flo36VQu1fHSpv1kBSirkMWNDAiIQBd2',\
		'GaHDCUfITUsC/fLzzsElh+sHvBSdZ9LLM3M6MuaIzD17P3hty6YPEcJq5/ET5caY6RgeGBgeNrn/ytIdQKklHolmuVn45zSg0MVLb/d4DTCuZY',\
		'ydP/pyIA8ksLZm5J88t6o2JK+5agRnwYy5VV2PZRHZz7T+gcEWO8nsjf4DtKDnr+GnraeDumpE+SVEh0QwgCIIKa0u7DKYG+dFkzFx8UTpEbGF',\
		'cyk+Mf99g8xu1791Dk1UKLD5eqeubAPbgTLFY5mzJMIhpyLVeJnSTjj+YXueZfe05PQJRspoDfjGqqcx5owR1tpnciKJMQcNFpkzAhvmeyM2c/',\
		'ooufpMtLb/AAAihKVB8ivIp+ofPG+hLPSxTyRGmptIAmSB9Z8ka5stoRBrSGEoipRSC8szRMy7rgjaeAmEtxFlMCDP8we6OZdfGnAxXb6OK1w+s='
	),
	'git',
	'monalisa.rsa.pub',
	now(),
	now(),
	now(),
	@mona_id,
	@mona_id,
	'user',
	0,
	'5FA3bBGFrbZJ/GXIzCmmVTdZN48ou08J4JKo3/6W6dI'
),(
	@collab_id,
	concat(
		'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEYc5zi/qTYo2vUtW0pFfxMYtabD27BaJaKXEOI+/+pFG8sYchhoaQ1pfpurcTah7F7fDB4s',\
		'ObJCIZ1XlLd96TKgzQWLTcVzBHH7E0XO4XrA64vP59RvrcPuel98vt0ymj+cg+Qh6xzn5OK+vA/AxIpds9pY/Ey3BoDmdRfV9VA3Z8U7EgNj2w',\
		'Y2ZQ8P0nUDecFnrB9yX0Z78RygUhXTkgL+ONluN8b+CN0LzbzN947U1IG+Q1rbbqVXV0dmzPLxBqvfP8/IKbDRAi6UOxaqv/JTFZcA2LkJGoBx',\
		'Ru392pMNo/daT0vTO6SVlz2GY4iWEWaVpStkC0AfHIHYigVhWS1dnPcnftLl2r9gKLTIhO+WT0f1P4E8CfGNOdRq5xsiyc3C9Wr+mbWDlQabAZ',\
		'wdafjwO3j7eApH6GkVsF+wxPFBz4lP1PCjor3eEGQHR5cIiIEZCqcVW/A07tBZU5P5U8aSmaQ1jryjaX5vSVqjvHNRsARQ/jXPPo/pMyKIh2dBU='
	),
	'git',
	'collaborator.rsa.pub',
	now(),
	now(),
	now(),
	@collab_id,
	@collab_id,
	'user',
	0,
	'SMg0roZheDfTiXpT+GxGQHTksZYGRAXKMv02ILDSu5I'
);
EOF
