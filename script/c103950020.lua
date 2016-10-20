--Light Shard Dragon
function c103950020.initial_effect(c)

	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--ATK trace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c103950020.atktrace)
	c:RegisterEffect(e1)
	
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950020,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c103950020.spcon)
	e2:SetTarget(c103950020.sptg)
	e2:SetOperation(c103950020.spop)
	c:RegisterEffect(e2)
	
	--Self-destruct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c103950020.sdcon)
	c:RegisterEffect(e3)
end

-- ATK trace operation
function c103950020.atktrace(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetFlagEffectLabel(103950020)
	if not atk then
		c:RegisterFlagEffect(103950020,RESET_EVENT+RESET_TOFIELD,0,1,c:GetAttack())
	else
		c:SetFlagEffectLabel(103950020,c:GetAttack())
	end
end

-- Special Summon condition
function c103950020.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local crp=c:GetReasonPlayer()
	local atk=c:GetFlagEffectLabel(103950020)
	return c:GetPreviousControler()==tp and tp~=crp and crp~=PLAYER_NONE and atk and atk >= 2000
end
-- Special Summon target
function c103950020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
-- Special Summon operation
function c103950020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local atk=c:GetFlagEffectLabel(103950020)
	if atk and atk >= 2000 then

		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk-500)
		c:RegisterEffect(e1)
		
	end
end

-- Self-destruct condition
function c103950020.sdcon(e)
	return e:GetHandler():GetAttack() > 3000
end