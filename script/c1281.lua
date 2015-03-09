--N领域 翠之梦境
function c1281.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1281+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1281.sptg)
	e1:SetOperation(c1281.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1281,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1281.condition)
	e2:SetTarget(c1281.shtg)
	e2:SetOperation(c1281.shop)
	c:RegisterEffect(e2)
end
function c1281.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x21a) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c1281.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c1281.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1281.filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1281.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1281.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c1281.cfilter(c)
	return c:IsFaceup() and c:IsCode(1279)
end
function c1281.dfilter(c)
	return c:IsFaceup() and c:IsCode(1280)
end
function c1281.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1281.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	and Duel.IsExistingMatchingCard(c1281.dfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c1281.tfilter(c)
	return c:IsSetCard(0x21a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1281.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1281.tfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c1281.shop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1281.tfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_COST)
	end
end
