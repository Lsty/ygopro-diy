--哈德曼的妖怪少女 古明地恋
function c93300002.initial_effect(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(c93300002.lvval)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c93300002.thcon)
	e2:SetTarget(c93300002.thtg)
	e2:SetOperation(c93300002.thop)
	c:RegisterEffect(e2)
end
function c93300002.lvval(e,c)
	local tp=c:GetControler()
	local lv=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc~=e:GetHandler() and tc:IsSetCard(0x933) then lv=lv+1 end
	end
	return lv
end
function c93300002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and ((re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_PSYCHO)) or re:GetHandler():GetCode()==93300010)
end
function c93300002.filter(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack() and c:IsAbleToGrave()
end
function c93300002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93300002.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c93300002.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c93300002.thop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c93300002.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end