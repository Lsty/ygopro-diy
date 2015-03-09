--幻惑之瞳
function c9991561.initial_effect(c)
	c:SetUniqueOnField(1,0,9991561)
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
	e2:SetCondition(c9991561.sdcon)
	c:RegisterEffect(e2)
	--Direct Remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e3:SetCode(EFFECT_TO_DECK_REDIRECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetValue(LOCATION_REMOVED)
	e3:SetTarget(c9991561.rmtg)
	c:RegisterEffect(e3)
	--Remove 5 cards
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c9991561.condition)
	e4:SetTarget(c9991561.target)
	e4:SetOperation(c9991561.operation)
	c:RegisterEffect(e4)
end
function c9991561.sdfilter(c)
	return c:IsSetCard(0xfee) and c:IsFaceup()
end
function c9991561.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(c9991561.sdfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c9991561.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c9991561.condition(e,tp,eg,ep,ev,re,r,rp)
	return (not re or re:GetOwner()~=e:GetHandler()) and e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c9991561.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,0,0)
end
function c9991561.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)==0 then return end
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<=5 then g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0) else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g=Duel.SelectMatchingCard(1-tp,nil,tp,0,LOCATION_DECK,5,5,nil) end
	Duel.ConfirmCards(tp,g)
	Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
	Duel.ShuffleDeck(1-tp)
end
