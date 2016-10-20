--Spellbound Draco
function c103950009.initial_effect(c)

	--Set Spell/Trap from Grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950009,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c103950009.target)
	e1:SetOperation(c103950009.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(103950009,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c103950009.desreptg)
	e4:SetOperation(c103950009.desrepop)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	
end

--Set Spell/Trap filter
function c103950009.tgfilter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
--Set Spell/Trap target
function c103950009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and
		Duel.IsExistingMatchingCard(c103950009.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c103950009.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
--Set Spell/Trap operation
function c103950009.operation(e,tp,eg,ep,ev,re,r,rp)

	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
		
		local c = e:GetHandler()
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e2,true)
	end
end

--Destruction replace filter
function c103950009.desrepfilter(c)
	return c:GetSequence()~=5 and c:IsDestructable()
end
--Destruction replace target
function c103950009.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) and
		Duel.IsExistingMatchingCard(c103950009.desrepfilter,tp,LOCATION_SZONE,0,1,nil) end
		
	if Duel.SelectYesNo(tp,aux.Stringid(103950009,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c103950009.desrepfilter,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.SetTargetCard(g)
		return true
	else return false end
end
--Destruction replace operation
function c103950009.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end