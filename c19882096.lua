--スケアクロー・ベロネア
function c19882096.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19882096+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c19882096.hspcon)
	e1:SetValue(c19882096.hspval)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c19882096.ptg)
	c:RegisterEffect(e2)
end
function c19882096.cfilter(c)
	return c:IsSetCard(0x17a) and c:IsFaceup()
end
function c19882096.getzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c19882096.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
	local seq=tc:GetSequence()
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
		if seq<5 then
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=zone|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=zone|(1<<(seq+1)) end
		end
	end
	return bit.band(zone,0x1f)
end
function c19882096.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c19882096.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c19882096.hspval(e,c)
	local tp=c:GetControler()
	return 0,c19882096.getzone(tp)
end
function c19882096.ptg(e,c)
	return c:IsSetCard(0x17a) and c:GetSequence()>=5
end
