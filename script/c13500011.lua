--究极犯规生命体 鬼人正邪
function c13500011.initial_effect(c)
	c:SetUniqueOnField(1,0,13500011)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c13500011.spcon)
	e2:SetOperation(c13500011.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c13500011.efilter)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c13500011.discon)
	e4:SetTarget(c13500011.distg)
	e4:SetOperation(c13500011.disop)
	c:RegisterEffect(e4)
	--swap ad
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c13500011.targeta)
	e5:SetCode(EFFECT_SWAP_BASE_AD)
	c:RegisterEffect(e5)
end
function c13500011.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x135) and c:IsAbleToGraveAsCost()
end
function c13500011.spfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x135)
end
function c13500011.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-4
		and Duel.CheckReleaseGroup(c:GetControler(),c13500011.spfilter1,4,nil)
end
function c13500011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c13500011.spfilter1,4,4,nil)
	Duel.Release(g,REASON_COST)
end
function c13500011.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() then return true end
	if te:IsActiveType(TYPE_EFFECT) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()then
		local atk=e:GetHandler():GetBaseAttack()
		local def=e:GetHandler():GetBaseDefence()
		local ec=te:GetHandler()
		return ec:GetBaseAttack()~=atk and ec:GetBaseDefence()~=def
	end
	return false
end
function c13500011.discon(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_EFFECT))
		or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_MZONE)
end
function c13500011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c13500011.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c13500011.targeta(e,c)
	return c~=e:GetHandler()
end