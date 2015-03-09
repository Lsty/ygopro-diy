--落语之芜罗亭
function c29500006.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FLIP)
	e1:SetTarget(c29500006.target)
	e1:SetOperation(c29500006.operation)
	c:RegisterEffect(e1)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_BEASTWARRIOR))
	e4:SetValue(c29500006.tgvalue)
	c:RegisterEffect(e4)
end
function c29500006.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c29500006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return Duel.IsExistingTarget(c29500006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c29500006.filter,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c29500006.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local og=Duel.SelectTarget(1-tp,c29500006.filter,1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp)
	local sc=sg:GetFirst()
	local oc=og:GetFirst()
	local g=Group.FromCards(sc,oc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
	e:SetLabelObject(sc)
end
function c29500006.operation(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local oc=g:GetFirst()
	if oc==sc then oc=g:GetNext() end
	if sc and sc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
	if oc and oc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(oc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c29500006.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end