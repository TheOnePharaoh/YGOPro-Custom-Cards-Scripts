--The Idol Master of Fantasy and Calamity Lord Phantasmia
function c59821076.initial_effect(c)
	c:SetCounterLimit(0x1114,5)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c59821076.spcon)
	e1:SetOperation(c59821076.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetDescription(aux.Stringid(59821076,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c59821076.destg)
	e4:SetOperation(c59821076.desop)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa1a2))
	e5:SetValue(c59821076.atkval)
	c:RegisterEffect(e5)
	--counter add
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821076,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c59821076.tokcon)
	e6:SetOperation(c59821076.tokop)
	c:RegisterEffect(e6)
	--Destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c59821076.desreptg)
	e7:SetOperation(c59821076.desrepop)
	c:RegisterEffect(e7)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_DESTROYING)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c59821076.damcon)
	e8:SetOperation(c59821076.damop)
	c:RegisterEffect(e8)
end
function c59821076.spfilter1(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xa1a2) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c59821076.spfilter2(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xa1a2) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c59821076.spfilter3(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xa1a2) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c59821076.spfilter4(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0xa1a2) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c59821076.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c59821076.spfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c59821076.spfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c59821076.spfilter3,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c59821076.spfilter4,tp,LOCATION_MZONE,0,1,nil)
end
function c59821076.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c59821076.spfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c59821076.spfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c59821076.spfilter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=Duel.SelectMatchingCard(tp,c59821076.spfilter4,tp,LOCATION_MZONE,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c59821076.desfilter(c,def)
	return c:IsFaceup() and c:GetAttack()<=def and c:IsDestructable()
end
function c59821076.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c59821076.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c59821076.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c59821076.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetDefense())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*800)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c59821076.tokfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049) and c:GetPreviousControler()==tp
end
function c59821076.tokcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c59821076.tokfilter,1,nil,tp)
end
function c59821076.tokop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1114,1)
end
function c59821076.atkval(e,c)
	return e:GetHandler():GetCounter(0x1114)*200
end
function c59821076.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x1114)>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(59821076,2))
end
function c59821076.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1114,2,REASON_EFFECT)
end
function c59821076.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821076.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end