--月见的灾厄天使 怨红灯
function c128816.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(128816,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c128816.target2)
	e1:SetOperation(c128816.operation2)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c128816.synlimit)
	c:RegisterEffect(e2)
end
function c128816.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x9fe)
end
function c128816.sfilter(c)
	return c:IsSetCard(0x9fe) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup() 
end
function c128816.fkfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_FAIRY)
end
function c128816.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c128816.sfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
	and Duel.GetMatchingGroupCount(c128816.fkfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)==0 end
end
function c128816.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c128816.sfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if g:GetCount()>0 then
		local t={}
		local i=1
		for i=1,4 do t[i]=i end
		local lv=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128816,0))
		local tg=Duel.SelectMatchingCard(tp,c128816.sfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
		local tc=tg:GetFirst()
		if  tc then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			e1:SetValue(lv)
			tc:RegisterEffect(e1)
		end
	end
end
