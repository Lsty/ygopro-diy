--猎魔人的魔物 萨麦尔
function c20130338.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c20130338.spcon)
	e1:SetOperation(c20130338.spop1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c20130338.spcost2)
	e2:SetTarget(c20130338.target)
	e2:SetOperation(c20130338.activate)
	c:RegisterEffect(e2)
end
function c20130338.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsCode,2,nil,20130326)
end
function c20130338.spop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,2,2,nil,20130326)
	Duel.Release(g,REASON_COST)
end
function c20130338.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,20130326) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,20130326)
	Duel.Release(g,REASON_COST)
end
function c20130338.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c20130338.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20130338.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20130338.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20130338.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c20130338.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
	end
end