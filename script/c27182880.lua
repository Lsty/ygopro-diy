--魔法都市エンディミオン
function c27182880.initial_effect(c)
	c:SetUniqueOnField(1,0,27182880)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c27182880.desreptg)
	e3:SetOperation(c27182880.desrepop)
	c:RegisterEffect(e3)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27182880,2))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c27182880.addct2)
	e5:SetOperation(c27182880.addc2)
	c:RegisterEffect(e5)
	--Add counter2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c27182880.addop2)
	c:RegisterEffect(e6)
end
function c27182880.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0xf)>=1 end
	return Duel.SelectYesNo(tp,aux.Stringid(27182880,0))
end
function c27182880.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xf,1,REASON_EFFECT)
end
function c27182880.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=eg:GetFirst()
	while c~=nil do
		if not c:IsCode(27182880) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) then
			count=count+c:GetCounter(0xf)
		end
		c=eg:GetNext()
	end
	if count>0 then
		e:GetHandler():AddCounter(0xf,count)
	end
end
function c27182880.addct2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsCanAddCounter(0xf,2) end
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf,2,REASON_EFFECT)
		and Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),0xf,2) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27182880,1))
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),0xf,2)
end
function c27182880.addc2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0xf)==0 then return end
	c:RemoveCounter(tp,0xf,2,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xf,2)
	end
end