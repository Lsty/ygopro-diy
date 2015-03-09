--White★Rock Shooter
function c20121126.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c20121126.syncon)
	e1:SetOperation(c20121126.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c20121126.rmtg)
	e4:SetOperation(c20121126.rmop)
	c:RegisterEffect(e4)
	--annnot activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(c20121126.aclimit)
	c:RegisterEffect(e5)
end
function c20121126.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c20121126.synfilter1(c,lv,g)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local t=false
	if c:IsType(TYPE_TUNER) then t=true end
	g:RemoveCard(c)
	local res=g:IsExists(c20121126.synfilter2,1,nil,lv-tlv,g,t)
	g:AddCard(c)
	return res
end
function c20121126.synfilter2(c,lv,g,tuner)
	if not c:IsCode(20121108) then return false end
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	if not tuner and not c:IsType(TYPE_TUNER) then return false end
	return g:IsExists(c20121126.synfilter3,1,c,lv-tlv)
end
function c20121126.synfilter3(c,lv)
	return c:IsNotTuner() and c:GetLevel()==lv
end
function c20121126.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c20121126.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then return c20121126.synfilter1(tuner,lv,mg) end
	return mg:IsExists(c20121126.synfilter1,1,nil,lv,mg)
end
function c20121126.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c20121126.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then
		local lv1=tuner:GetLevel()
		local t=false
		if tuner:IsType(TYPE_TUNER) then t=true end
		mg:RemoveCard(tuner)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=mg:FilterSelect(tp,c20121126.synfilter2,1,1,nil,lv-lv1,mg,t)
		local m2=t2:GetFirst()
		g:AddCard(m2)
		local lv2=m2:GetLevel()
		mg:RemoveCard(m2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t3=mg:FilterSelect(tp,c20121126.synfilter3,1,1,nil,lv-lv1-lv2)
		g:Merge(t3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c20121126.synfilter1,1,1,nil,lv,mg)
		local m1=t1:GetFirst()
		g:AddCard(m1)
		local lv1=m1:GetLevel()
		local t=false
		if m1:IsType(TYPE_TUNER) then t=true end
		mg:RemoveCard(m1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=mg:FilterSelect(tp,c20121126.synfilter2,1,1,nil,lv-lv1,mg,t)
		local m2=t2:GetFirst()
		g:AddCard(m2)
		local lv2=m2:GetLevel()
		mg:RemoveCard(m2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t3=mg:FilterSelect(tp,c20121126.synfilter3,1,1,nil,lv-lv1-lv2)
		g:Merge(t3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c20121126.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsType(TYPE_EFFECT) and tc:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c20121126.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() and tc:IsFaceup() then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
function c20121126.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler()~=e:GetHandler()
end