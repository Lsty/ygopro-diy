--天灾之龙 煌黑龙
function c11112040.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11112040.syncon)
	e1:SetOperation(c11112040.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11112040.immcon)
	e3:SetOperation(c11112040.immop)
	c:RegisterEffect(e3)
	--send to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11112040,0))
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c11112040.sdtg)
	e4:SetOperation(c11112040.sdop)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11112040,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCategory(CATEGORY_DECKDESS)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(c11112040.spcon)
	e5:SetTarget(c11112040.sptg)
	e5:SetOperation(c11112040.spop)
	c:RegisterEffect(e5)
end
function c11112040.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x15b) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c11112040.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x15b) and c:IsCanBeSynchroMaterial(syncard)
end
function c11112040.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	return g1:IsExists(c11112040.synfilter2,1,c,lv-tlv,g2,f1,c)
end
function c11112040.synfilter2(c,lv,g2,f1,tuner1)
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	return g2:IsExists(c11112040.synfilter3,1,nil,lv-tlv,f1,f2)
end
function c11112040.synfilter3(c,lv,f1,f2)
	return c:GetLevel()==lv and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c11112040.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=Duel.GetMatchingGroup(c11112040.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c11112040.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetLevel()
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c11112040.synfilter2,1,tuner,lv-tlv,g2,f1,tuner)
		else
			return c11112040.synfilter2(pe:GetOwner(),lv-tlv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c11112040.synfilter1,1,nil,lv,g1,g2)
	else
		return c11112040.synfilter1(pe:GetOwner(),lv,g1,g2)
	end
end
function c11112040.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c11112040.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c11112040.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetLevel()
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c11112040.synfilter2,1,1,tuner,lv-lv1,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetLevel()
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c11112040.synfilter3,1,1,nil,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c11112040.synfilter1,1,1,nil,lv,g1,g2)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetLevel()
		local f1=tuner1.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c11112040.synfilter2,1,1,tuner1,lv-lv1,g2,f1,tuner1)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetLevel()
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c11112040.synfilter3,1,1,nil,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c11112040.immcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11112040.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c11112040.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function c11112040.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c11112040.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>1 
	    and Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11112040.sdop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)<2 then return end
    Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsSetCard,nil,0x15b)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	    local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	    Duel.HintSelection(dg)
	    Duel.SendtoGrave(dg,REASON_EFFECT)
	end
end
function c11112040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c11112040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	    and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11112040.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.DiscardDeck(tp,4,REASON_EFFECT)
	if e:GetHandler():IsRelateToEffect(e) then
	    local g=Duel.GetOperatedGroup()
		if g:FilterCount(Card.IsSetCard,nil,0x15b)>=3 then
		    Duel.ConfirmCards(1-tp,g)
		    Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
		end	
	end
end