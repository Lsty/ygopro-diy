--夜夜  天险绝冲 :破却水月
function c1314524.initial_effect(c)
    c:EnableReviveLimit()
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314524,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x2)
	e1:SetCountLimit(1,1314524)
	e1:SetCost(c1314524.shcost)
	e1:SetTarget(c1314524.shtg)
	e1:SetOperation(c1314524.shop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c1314524.reptg)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENCE_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end	
function c1314524.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(0x1000000) and Duel.CheckLPCost(tp,1000) end
	if Duel.SelectYesNo(tp,aux.Stringid(1314524,1)) then
		Duel.PayLPCost(tp,1000) 
		return true
	else return false end
end
function c1314524.sfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x9ff) and not c:IsCode(1314526) and c:IsAbleToHand()
end	
function c1314524.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),0x5,0x80) 
end
function c1314524.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1314524.sfilter,tp,0x1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x1)
end
function c1314524.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1314524.sfilter,tp,0x1,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
