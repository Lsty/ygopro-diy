--休眠的古龙
function c9990803.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9990803.target)
	e1:SetOperation(c9990803.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9990803.handcon)
	c:RegisterEffect(e2)
end
function c9990803.confilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_WYRM)
end
function c9990803.handcon(e)
	return Duel.GetMatchingGroupCount(c9990803.confilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)==0
end
function c9990803.filter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(c:GetOwner(),LOCATION_MZONE)~=0
end
function c9990803.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c9990803.filter(chkc) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(c9990803.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9990803.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c9990803.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):GetFirst()
	if not tc then return end local race=tc:GetOriginalRace() local tkp=tc:GetOwner()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tkp,LOCATION_MZONE)==0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,9980001,0,0x4011,0,0,2,0x800000,0x20,0x4,tkp) then return end
		Duel.BreakEffect() local token=Duel.CreateToken(tp,9980001)
		Duel.SpecialSummonStep(token,0,tp,tkp,false,false,POS_FACEUP_DEFENCE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
		e2:SetValue(1)
		e2:SetTarget(c9990803.syntg)
		e2:SetOperation(c9990803.synop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3:SetValue(c9990803.synlimit)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(race)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end
function c9990803.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(e:GetHandler():GetRace())
end
function c9990803.synfilter(c,syncard,tuner,f,lv)
	return c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c)) and c:GetLevel()==lv and c:IsRace(tuner:GetRace())
end
function c9990803.syntg(e,syncard,f,minc,maxc)
	if minc>1 then return false end
	local lv=syncard:GetLevel()-e:GetHandler():GetLevel()
	if lv<=0 then return false end
	return Duel.IsExistingMatchingCard(c9990803.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil,syncard,e:GetHandler(),f,lv)
end
function c9990803.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local lv=syncard:GetLevel()-e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9990803.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,syncard,e:GetHandler(),f,lv)
	Duel.SetSynchroMaterial(g)
end
