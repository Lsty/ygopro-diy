--目隐团·绝对天才·如月伸太郎
function c19900031.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c19900031.syncon)
	e1:SetOperation(c19900031.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19900031,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c19900031.discon)
	e3:SetTarget(c19900031.distg)
	e3:SetOperation(c19900031.disop)
	c:RegisterEffect(e3)
	--suicide
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19900031,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c19900031.destg)
	e4:SetOperation(c19900031.desop)
	c:RegisterEffect(e4)
end
function c19900031.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsSetCard(0x199) and c:IsCanBeSynchroMaterial(syncard)
end
function c19900031.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSynchroMaterial(syncard)
end
function c19900031.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	return g1:IsExists(c19900031.synfilter2,1,c,lv-tlv,g2,f1,c)
end
function c19900031.synfilter2(c,lv,g2,f1,tuner1)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	return g2:IsExists(c19900031.synfilter3,1,nil,lv-tlv,f1,f2)
end
function c19900031.synfilter3(c,lv,f1,f2)
	return c:GetLevel()==lv and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c19900031.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=Duel.GetMatchingGroup(c19900031.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c19900031.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetLevel()
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		return g1:IsExists(c19900031.synfilter2,1,tuner,lv-tlv,g2,f1,tuner)
	end
	return g1:IsExists(c19900031.synfilter1,1,nil,lv,g1,g2)
end
function c19900031.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c19900031.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c19900031.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetLevel()
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c19900031.synfilter2,1,1,tuner,lv-lv1,g2,f1,tuner)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetLevel()
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c19900031.synfilter3,1,1,nil,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=g1:FilterSelect(tp,c19900031.synfilter1,1,1,nil,lv,g1,g2)
		local tuner1=t1:GetFirst()
		g:AddCard(tuner1)
		local lv1=tuner1:GetLevel()
		local f1=tuner1.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c19900031.synfilter2,1,1,tuner1,lv-lv1,g2,f1,tuner1)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetLevel()
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c19900031.synfilter3,1,1,nil,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c19900031.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c19900031.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function c19900031.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c19900031.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19900031)==0 and e:GetHandler():IsDestructable() end
	Duel.RegisterFlagEffect(tp,19900031,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c19900031.exfilter(c,e,tp)
	return c:IsSetCard(0x199) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19900031.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c19900031.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end