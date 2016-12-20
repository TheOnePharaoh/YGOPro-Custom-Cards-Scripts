--Isadore, Combustion Phoenix
function c66666656.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(66666656,1))
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c66666656.atktg1)
	e2:SetOperation(c66666656.atkop1)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c66666656.splimit)
	c:RegisterEffect(e3)
	--SS on destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c66666656.sumtg)
	e4:SetOperation(c66666656.sumop)
	c:RegisterEffect(e4)
	--spsum success
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11260714,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c66666656.descon)
	e5:SetTarget(c66666656.destg)
	e5:SetOperation(c66666656.desop)
	c:RegisterEffect(e5)
	
	
end

function c66666656.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x29b) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c66666656.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x29b)
end
function c66666656.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  e:GetHandler():IsDestructable() and chkc:IsLocation(LOCATION_MZONE) 
		and chkc:IsControler(tp) and c66666656.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666656.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666656.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66666656.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c66666656.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c66666656.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function c66666656.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) or e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c66666656.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66666656.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	end
end