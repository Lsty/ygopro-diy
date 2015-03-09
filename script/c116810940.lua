--紫电的⑨
function c116810940.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116810940,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c116810940.setcon)
	e1:SetTarget(c116810940.sptg)
	e1:SetOperation(c116810940.spop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(116810940,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,116810940)
	e2:SetCost(c116810940.thcost)
	e2:SetTarget(c116810940.thtg)
	e2:SetOperation(c116810940.thop)
	c:RegisterEffect(e2)
end
function c116810940.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c116810940.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c116810940.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c116810940.filter1(c,e,tp,lv)
 local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0x3e6) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c116810940.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+c:GetLevel())
end
function c116810940.filter2(c,e,tp,lv)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_FUSION) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true)
end
function c116810940.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_HAND) and c116810940.filter1(chkc,e,tp,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsAbleToHand()
		and Duel.IsExistingTarget(c116810940.filter1,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectTarget(tp,c116810940.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c116810940.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv=c:GetLevel()+tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c116810940.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
	         Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
			 sg:GetFirst():CompleteProcedure()
		end
	end
end
function c116810940.thfilter(c)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_MONSTER) and not c:IsCode(116810940) and c:IsAbleToRemoveAsCost()
end
function c116810940.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116810940.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c116810940.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c116810940.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c116810940.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end