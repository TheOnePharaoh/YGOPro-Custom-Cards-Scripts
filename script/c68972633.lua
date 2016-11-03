--Predator Plant Wyvern Horror
function c68972633.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,33763359,c68972633.ffilter,1,true,false)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c68972633.ccon)
	e1:SetTarget(c68972633.ctg)
	e1:SetOperation(c68972633.cop)
	c:RegisterEffect(e1)
		--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000674,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c68972633.target)
	e2:SetOperation(c68972633.operation)
	c:RegisterEffect(e2)
end
function c68972633.ffilter(c)
	return c:GetLevel()==4 and c:IsSetCard(0x10f3)
end
function c68972633.ccon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
  return c:IsSummonType(SUMMON_TYPE_FUSION) 
end
function c68972633.cfil(c)
  return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c68972633.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c68972633.cfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectTarget(tp,c68972633.cfil,tp,0,LOCATION_MZONE,1,2,nil)
end
function c68972633.cop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		tc:AddCounter(0x1041,1)
		tc=g:GetNext()
		end
       end
end

function c68972633.filter(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function c68972633.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c68972633.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c68972633.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c68972633.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(tc:GetBaseAttack())
			c:RegisterEffect(e2)
		end
	end
end