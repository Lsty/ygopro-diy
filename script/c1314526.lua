--夜夜 光焰绝冲:夜樱乱舞
function c1314526.initial_effect(c)
    c:EnableReviveLimit()
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314526,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x2)
	e1:SetCountLimit(1,1314526)
	e1:SetCost(c1314526.shcost)
	e1:SetTarget(c1314526.shtg)
	e1:SetOperation(c1314526.shop)
	c:RegisterEffect(e1)
	--multiattack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c1314526.sfilter(c)
	return c:IsType(0x1) and c:IsSetCard(0x9fd) and not c:IsCode(1314526) and c:IsAbleToHand()
end	
function c1314526.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),0x5,0x80) 
end
function c1314526.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1314526.sfilter,tp,0x1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x1)
end
function c1314526.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1314526.sfilter,tp,0x1,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
