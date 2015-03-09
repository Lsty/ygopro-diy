--来自墓场的悲鸣
function c9991560.initial_effect(c)
	c:SetUniqueOnField(1,0,9991560)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Self Destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c9991560.sdcon)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9991560.condition2)
	e3:SetTarget(c9991560.target2)
	e3:SetOperation(c9991560.operation2)
	c:RegisterEffect(e3)
	--Remove 2 Cards
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCondition(c9991560.condition)
	e4:SetTarget(c9991560.target)
	e4:SetOperation(c9991560.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e7)
end
function c9991560.sdfilter(c)
	return c:IsSetCard(0xfee) and c:IsFaceup()
end
function c9991560.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(c9991560.sdfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c9991560.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst() ck=0
	while tc and ck==0 do if tc:IsReason(REASON_EFFECT) and tc:IsPreviousLocation(LOCATION_HAND) and tc:GetPreviousControler()==1-tp
		then ck=1 end tc=eg:GetNext() end
	return ck==1
end
function c9991560.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
end
function c9991560.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetDecktopGroup(1-tp,2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c9991560.condition2(e,tp,eg,ep,ev,re,r,rp)
	return (not re or re:GetOwner()~=e:GetHandler()) and e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c9991560.gfilter(c)
	return c:IsSetCard(0xfee) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsType(TYPE_PENDULUM)) and c:GetCode()~=9991560
end
function c9991560.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10+0x40)
end
function c9991560.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c9991560.gfilter,tp,0x10+0x40,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9991560.gfilter,tp,0x10+0x40,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g)
end
