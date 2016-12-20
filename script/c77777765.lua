--Hellformed Girl Scynthia
function c77777765.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777765,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,77777765)
	e2:SetCondition(c77777765.spcon)
	e2:SetOperation(c77777765.spop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c77777765.splimit)
	c:RegisterEffect(e3)
	--effect indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(c77777765.valcon)
	c:RegisterEffect(e4)
	--attack twice
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c77777765.damcon)
	e6:SetTarget(c77777765.damtg)
	e6:SetOperation(c77777765.damop)
	c:RegisterEffect(e6)
	--atk up
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77777765,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetTarget(c77777765.atktg1)
	e7:SetOperation(c77777765.atkop1)
	c:RegisterEffect(e7)
	--cannot direct attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
end

function c77777765.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_FIEND) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777765.spfilter(c,e,tp)
	return c:IsSetCard(0x3e7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777765.spcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0x3e7) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0x3e7)
end
function c77777765.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c77777765.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c77777765.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c77777765.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,500,REASON_EFFECT)
end

function c77777765.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end

function c77777765.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3e7)
end
function c77777765.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77777765.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777765.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77777765.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77777765.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end