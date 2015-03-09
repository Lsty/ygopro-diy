--震轰眼·磐
function c210005.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,2100051)
	e1:SetCondition(c210005.spcon)
	e1:SetOperation(c210005.spop)
	c:RegisterEffect(e1)
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210005,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,2100052)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c210005.pcon)
	e2:SetCost(c210005.pcost)
	e2:SetTarget(c210005.ptg)
	e2:SetOperation(c210005.pop)
	c:RegisterEffect(e2)
	--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(210005,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,2100053)
	e3:SetCondition(c210005.thcon)
	e3:SetTarget(c210005.thtg)
	e3:SetOperation(c210005.thop)
	c:RegisterEffect(e3)
end
function c210005.spfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsRace(RACE_FIEND) 
end
function c210005.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c210005.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,1,e:GetHandler())
end
function c210005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c210005.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c210005.rettg)
	e1:SetOperation(c210005.retop)
	e:GetHandler():RegisterEffect(e1)
end
function c210005.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c210005.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)  
end
function c210005.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c210005.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c210005.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsPosition(POS_FACEUP_ATTACK) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),POS_FACEUP_ATTACK) end
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),POS_FACEUP_ATTACK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c210005.pop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),POS_FACEUP_ATTACK)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
	end
end
function c210005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c210005.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:GetLevel()==6 and c:IsAbleToHand()
		   and not c:IsCode(210005)
end
function c210005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end